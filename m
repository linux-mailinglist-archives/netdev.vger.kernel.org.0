Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FF32FCF04
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbhATLQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:45 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6185 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387752AbhATKnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:43:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600809050003>; Wed, 20 Jan 2021 02:42:13 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 10:42:13 +0000
Date:   Wed, 20 Jan 2021 12:42:10 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "Nikolay Aleksandrov" <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net: set link down before enslave
Message-ID: <20210120104210.GA2602142@shredder.lan>
References: <20210120102947.2887543-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210120102947.2887543-1-liuhangbin@gmail.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611139333; bh=MhhO+3S+too0ML77p32Ws8caYMQRhYo/L+AtugoRRkE=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=iaxL8tJowapBHs9GDsOMlzjTFAnnVxn4L9QYORRFdTRCc8RfVtGeD+FUNPOhweSF5
         hZr4LEyBN3LsUbq53lvfK/tJGXyOY4Fy3fQOpcHVGX2teWZwUQoQdIxGs8RQZinEBg
         ID7q21pSxEgLPUHympV1TSYucshYcADk/7R8SoebIS6WCjvTAM5AmRN4kvHba/ZZlk
         Pi9OanERrmpZE/GqEKkZTMv99ulCzBzCy2wKeZfKEYnlGLAChAphA/LS8NGSVCRJb+
         AK7iloEhNICi+ztKKCq2ZkeLAIZJzPv28Qzt5pT/qXgUypgbS0TfBm+WAsNt4acCAs
         1ExJarz9gAdOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 06:29:47PM +0800, Hangbin Liu wrote:
> Set the link down before enslave it to a bond device, to avoid
> Error: Device can not be enslaved while up.
> 
> Fixes: 6374a5606990 ("selftests: rtnetlink: Test bridge enslavement with different parent IDs")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/rtnetlink.sh | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> index c9ce3dfa42ee..a26fddc63992 100755
> --- a/tools/testing/selftests/net/rtnetlink.sh
> +++ b/tools/testing/selftests/net/rtnetlink.sh
> @@ -1205,6 +1205,8 @@ kci_test_bridge_parent_id()
>  	dev20=`ls ${sysfsnet}20/net/`
>  
>  	ip link add name test-bond0 type bond mode 802.3ad
> +	ip link set dev $dev10 down
> +	ip link set dev $dev20 down

But these netdevs are created with their administrative state set to
'DOWN'. Who is setting them to up?

>  	ip link set dev $dev10 master test-bond0
>  	ip link set dev $dev20 master test-bond0
>  	ip link add name test-br0 type bridge
> -- 
> 2.26.2
> 
