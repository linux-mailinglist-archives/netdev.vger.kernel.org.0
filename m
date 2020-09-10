Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC3264384
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgIJKQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:16:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730436AbgIJKQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 06:16:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 766C8B25F;
        Thu, 10 Sep 2020 10:16:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9120B60311; Thu, 10 Sep 2020 12:16:05 +0200 (CEST)
Date:   Thu, 10 Sep 2020 12:16:05 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] tunnels: implement new --show-tunnels command
Message-ID: <20200910101605.ivuohkkgnt4hi5qs@lion.mk-sys.cz>
References: <20200909221811.410014-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909221811.410014-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 03:18:11PM -0700, Jakub Kicinski wrote:
> Add support for the new show-tunnels command. Support dump.
> 
>  # ethtool --show-tunnels \*
> Tunnel information for eth0:
>   UDP port table 0:
>     Size: 4
>     Types: vxlan
>     No entries
>   UDP port table 1:
>     Size: 4
>     Types: geneve, vxlan-gpe
>     Entries (2):
>         port 1230, vxlan-gpe
>         port 6081, geneve
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

The patch looks good except for one cosmetic issue below. But you will
need to update the uapi header copies first to get the new constants.
You can use the script at the end of this mail.

[...]
> +static int
> +tunnel_info_dump_udp_entry(struct nl_context *nlctx, const struct nlattr *entry,
> +			   const struct stringset **strings)
> +{
> +	const struct nlattr *entry_tb[ETHTOOL_A_TUNNEL_UDP_ENTRY_MAX + 1] = {};
> +	DECLARE_ATTR_TB_INFO(entry_tb);
> +	const struct nlattr *attr;
> +	unsigned int port, type;
> +	int ret;
> +
> +	if (tunnel_info_strings_load(nlctx, strings))
> +		return 1;
> +
> +	ret = mnl_attr_parse_nested(entry, attr_cb, &entry_tb_info);
> +	if (ret < 0) {
> +		fprintf(stderr, "malformed netlink message (udp entry)\n");
> +		return 1;
> +	}
> +
> +	attr = entry_tb[ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT];
> +	if (!attr || mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
> +		fprintf(stderr, "malformed netlink message (port)\n");
> +		return 1;
> +	}
> +	port = htons(mnl_attr_get_u16(attr));

This should be ntohs() as the attribute is in network byte order and we
convert it to host byte order (the result is the same, of course).

> +
> +	attr = entry_tb[ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE];
> +	if (!attr || mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
> +		fprintf(stderr, "malformed netlink message (tunnel type)\n");
> +		return 1;
> +	}
> +	type = mnl_attr_get_u32(attr);
> +
> +	printf("        port %d, %s\n", port, get_string(*strings, type));
> +
> +	return 0;
> +}

The script below expects LINUX_GIT to be set to the directory with
kernel git repository. It takes an optional argument which is a tag or
commit id to import uapi headers from; without an argument it updates
from what is currently checked out in $LINUX_GIT. So you can run e.g.

    LINUX_GIT=~/git/kernel ethtool-import-uapi v5.9-rc1

Michal

------------------------------------------------------------------------------
#!/bin/bash -e

sn="${0##*/}"
export ARCH="x86_64"

if [ ! -d "$LINUX_GIT" ]; then
    echo "${sn}: LINUX_GIT not set" >&2
    exit 1
fi

pushd "$LINUX_GIT"
if [ -n "$1" ]; then
    git checkout "$1"
fi
desc=$(git describe --exact-match 2>/dev/null \
       || git show -s --abbrev=12 --pretty='commit %h')
kobj=$(mktemp -d)
make -j16 O="$kobj" allmodconfig
make -j16 O="$kobj" prepare
make -j16 O="$kobj" INSTALL_HDR_PATH="${kobj}/hdr" headers_install
popd

pushd uapi
find . -type f -name '*.h' -exec cp -v "${kobj}/hdr/include/{}" {} \;
popd
rm -rf "$kobj"

git add uapi
git commit -s -F - <<EOT
update UAPI header copies

Update to kernel ${desc}.

EOT
------------------------------------------------------------------------------
