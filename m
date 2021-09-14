Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CB340AC6A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhINL32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:29:28 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35247 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232124AbhINL3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:29:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id E947B5805B5;
        Tue, 14 Sep 2021 07:28:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Sep 2021 07:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dU3Nsjw82W/VcUZX2aY7ntGEaa4D2EK0lv10ohAqQ90=; b=Eb5R+3Hz
        FHBBGtsHwdc8k/lypOAJFHcIp1lFmBP5+CqwodwWrKVaHsbnPLdfgqoJeaDjw9Mh
        tT9KI0psWcAn4Hq+bqKOhXmLfCxN7ZRvsQ8aojC1J6iP3L62SzjI6f6cOo4OSFCH
        jShpIfyVkYb4V9+kSCP+KGGz88ftmp8tDvtE7uvvrmS2YZAOrtO9jUYkq1u9Co0O
        I28kn6dJZp1SXpe+Hjo8oKIgw2R5oSf3s3X+LAJEyZLVPYQPy7KtoXxLxyYu+8PP
        B7+aSPnRKPArfaZ+f45wIOTgZicXdEvgn6mMoqvF99cZkpTOyXSKyuNL81EhAkkZ
        XePyRqFvaYZ47g==
X-ME-Sender: <xms:RodAYQ_m7sxlqQKftu-inwiDwXqCNGURH0ZkNP5TN7AMGHKnNt390A>
    <xme:RodAYYuKM0SPqkdTgFyKIuZXcVAu-Np3dikTD9Di2YKbeWx5Jj199AEo-iZ-x93mE
    2E6pYvAR2ozUy8>
X-ME-Received: <xmr:RodAYWA375H0o40oRco7EgbxJQzsrJG7ixRAXzPL3ihZd5TnPZKUY72qX2KhoLENaTxduB9uATYDakQHecLy7ZWDnq2sCjgjMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RodAYQdA_p_wJ6ZZrm_iw23Pew_L1WKKWC4Re4Iad2iG-9UozEfWnA>
    <xmx:RodAYVNRf-G-GuUSXUInROJuujr-lRMlIdSaaNMHwJAntF7jnxw8Ng>
    <xmx:RodAYanOsNl__rGlgTOOg4EMOwgDXIsCmxxCUUhpGBk6DyyrrgX4Lw>
    <xmx:RodAYei3Wju-qhzNv4Pu0YsxtAsgYr8y-_2lQky6Cl9ca6YbFDZQhg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 07:28:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, popadrian1996@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool 3/5] netlink: eeprom: Fallback to IOCTL when a complete hex/raw dump is requested
Date:   Tue, 14 Sep 2021 14:27:36 +0300
Message-Id: <20210914112738.358627-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914112738.358627-1-idosch@idosch.org>
References: <20210914112738.358627-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The IOCTL backend provides a complete hex/raw dump of the module EEPROM
contents:

 # ethtool -m swp11 hex on | wc -l
 34

 # ethtool -m swp11 raw on | wc -c
 512

With the netlink backend, only the first 128 bytes from I2C address 0x50
are dumped:

 # ethtool -m swp11 hex on | wc -l
 10

 # ethtool -m swp11 raw on | wc -c
 128

The presence of optional / banked pages is unknown without parsing the
EEPROM contents which is unavailable when pretty printing is disabled
(i.e., configure --disable-pretty-dump). With the IOCTL backend, this
parsing happens inside the kernel.

Therefore, when a complete hex/raw dump is requested, fallback to the
IOCTL backend.

After the patch:

 # ethtool -m swp11 hex on | wc -l
 34

 # ethtool -m swp11 raw on | wc -c
 512

This avoids breaking users that are relying on current behavior.

If users want a hex/raw dump of optional/banked pages that are not
returned with the IOCTL backend, they will be required to request these
explicitly via the netlink backend. For example:

 # ethtool -m swp11 hex on page 0x2

This is desirable as that way there is no ambiguity regarding the
location of optional/banked pages in the dump.

Another way to implement the above would be to use the 'nlchk' callback
added in commit 67a9ef551661 ("ethtool: add nlchk for redirecting to
netlink"). However, it is called before the netlink instance is
initialized and before the command line parameters are parsed via
nl_parser().

Fixes: 25b64c66f58d ("ethtool: Add netlink handler for getmodule (-m)")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/module-eeprom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 38e7d2cd6cf3..e9a122df3259 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -365,6 +365,16 @@ int nl_getmodule(struct cmd_context *ctx)
 		return -EINVAL;
 	}
 
+	/* When complete hex/raw dump of the EEPROM is requested, fallback to
+	 * ioctl. Netlink can only request specific pages.
+	 */
+	if ((getmodule_cmd_params.dump_hex || getmodule_cmd_params.dump_raw) &&
+	    !getmodule_cmd_params.page && !getmodule_cmd_params.bank &&
+	    !getmodule_cmd_params.i2c_address) {
+		nlctx->ioctl_fallback = true;
+		return -EOPNOTSUPP;
+	}
+
 	request.i2c_address = ETH_I2C_ADDRESS_LOW;
 	request.length = 128;
 	ret = page_fetch(nlctx, &request);
-- 
2.31.1

