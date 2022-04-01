Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4934EE6F3
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242603AbiDAD4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbiDAD4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E810B133667
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D86A661AC8
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D51BC2BBE4;
        Fri,  1 Apr 2022 03:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648785251;
        bh=GD5htXBENXYvcyK/ofeksF7fMb7VevLRDmWcH2wD2YQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rhuw4yrubFppBc0P6TZx6Z1Ti1xNKBJyjmMBix7WuKbdfgCYBpmTtgtB8ojP9cM1E
         nbzHBMUy7MPVFlhby6mZOklDNj0nBGSuC0NrmBvk3fc6W4dyReVtsbRklRRLtSoub8
         4+OaA3eeTgVdHLcWX/JKsMkG5WgGB0Ll5OeLUzknMAHtUJbnApybdHo2uJOCIfGCTK
         Lget0wfdqjHiFPoBh80dhicD1vhXSUF94PTBrC8D49VFYg/5zRHZh7oBUODUTA239S
         DTBZjD9AY5Zk7zfLpuBJybD4ryIqXhW9CdCqSY7oKKpjT4IjApSNtfHCyzXDDonlaZ
         qvt220qzM27+A==
Date:   Thu, 31 Mar 2022 20:54:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH net-next] rtnetlink: enable alt_ifname for
 setlink/newlink
Message-ID: <20220331205410.392efbf0@kernel.org>
In-Reply-To: <20220331123728.7267-1-florent.fourcot@wifirst.fr>
References: <20220331123728.7267-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 14:37:28 +0200 Florent Fourcot wrote:
> buffer is always valid when called by setlink/newlink,
> but contains only empty string when IFLA_IFNAME is not given. So
> IFLA_ALT_IFNAME is always ignored
> 
> Fixes: 76c9ac0ee878 ("net: rtnetlink: add possibility to use alternative names as message handle")

Again, you most definitely need to CC the author of the code under
Fixes, they may have some context we don't.

Since this is a fix the subject tag should be [PATCH net].

> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 3313419bbcba..613065a53b34 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2979,7 +2979,7 @@ static struct net_device *rtnl_dev_get(struct net *net,
>  {
>  	char buffer[ALTIFNAMSIZ];
>  
> -	if (!ifname) {
> +	if (!ifname || !ifname[0]) {

Unless I'm missing something this function is loading a footgun to 
save copying 16B twice. I'd remove the ifname argument, it's always
populated from ifname_attr by the callers AFAICT.
