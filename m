Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2A52E9476
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 13:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbhADMB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 07:01:58 -0500
Received: from correo.us.es ([193.147.175.20]:58792 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbhADMB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 07:01:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ABA131C438B
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 13:00:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DF41DA797
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 13:00:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92C8ADA73D; Mon,  4 Jan 2021 13:00:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6155FDA789;
        Mon,  4 Jan 2021 13:00:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Jan 2021 13:00:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3DEAB426CC85;
        Mon,  4 Jan 2021 13:00:37 +0100 (CET)
Date:   Mon, 4 Jan 2021 13:01:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yi Chen <yiche@redhat.com>
Cc:     Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Leo <liuhangbin@gmail.com>
Subject: Re: [PATCH net] selftests: netfilter: Pass the family parameter to
 conntrack tool
Message-ID: <20210104120113.GA20112@salvia>
References: <20210104110723.43564-1-yiche@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210104110723.43564-1-yiche@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please, Cc netfilter-devel@vger.kernel.org, and a more few comments
below.

On Mon, Jan 04, 2021 at 07:07:23PM +0800, Yi Chen wrote:
> From: yiche <yiche@redhat.com>
> 
> Fix nft_conntrack_helper.sh fake fail:
> conntrack tool need "-f ipv6" parameter to show out ipv6 traffic items.
> sleep 1 second after background nc send packet, to make sure check
> result after this statement is executed.

Missing Fixes: tag ?

> Signed-off-by: yiche <yiche@redhat.com>
> ---
>  .../selftests/netfilter/nft_conntrack_helper.sh      | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
> index edf0a48da6bf..ebdf2b23c8e3 100755
> --- a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
> +++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
> @@ -94,7 +94,13 @@ check_for_helper()
>  	local message=$2
>  	local port=$3
>  
> -	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
> +	if [[ "$2" =~ "ipv6" ]];then
> +	local family=ipv6
> +	else
> +	local family=ipv4

This branch coding style diverges from the existing code.

> +	fi
