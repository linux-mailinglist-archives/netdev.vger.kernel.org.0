Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FF74DE1D2
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiCRTez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240335AbiCRTey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:34:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE84615FF2;
        Fri, 18 Mar 2022 12:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B57C7CE2A37;
        Fri, 18 Mar 2022 19:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7487CC340E8;
        Fri, 18 Mar 2022 19:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647632009;
        bh=rlCNB/iC0DSgJFF6MWt8576T/eRMP/b77KCnIge0EAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6eVDNtrG69YM9lKe6VIc7V8uSO+LylXRFp8tZTO9gJaxvAbhiDXfFYSidDro+23C
         EUalQJFuZ3QBGrxunNjzgHy0W2FDkiFq0GGnDFR55gJRQloy1tsJj8l1GpAxn9IUO4
         dRXJvx92pZla/5IJeILG4Wmi6bfWKb1uCs42MzInz8cyKQVA7GNL5qa8tXSAh5GMqf
         tUYjTXYk0t8pRaiSoAO2p2wPWwEFVtzJ2xNAY9Oxy+08UptaJ0pHR5eVDXiMkgH2ho
         xpr+SyKJKlt9ZA/puso4iydnJIIgS7ZDaSK4b4RSE1DVvt5gd0jvkJ5q/erH3s/YD3
         +8h+zaqi3+hWw==
Date:   Fri, 18 Mar 2022 12:33:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        pabeni@redhat.com, toke@redhat.com, lorenzo.bianconi@redhat.com,
        andrii@kernel.org, nbd@nbd.name
Subject: Re: [PATCH bpf-next] net: xdp: introduce XDP_PACKET_HEADROOM_MIN
 for veth and generic-xdp
Message-ID: <20220318123323.75973f84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <039064e87f19f93e0d0347fc8e5c692c789774e6.1647630686.git.lorenzo@kernel.org>
References: <039064e87f19f93e0d0347fc8e5c692c789774e6.1647630686.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 20:19:29 +0100 Lorenzo Bianconi wrote:
> diff --git a/net/core/dev.c b/net/core/dev.c
> index ba69ddf85af6..92d560e648ab 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4737,7 +4737,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  	 * native XDP provides, thus we need to do it here as well.
>  	 */
>  	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
> -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> +	    skb_headroom(skb) < XDP_PACKET_HEADROOM_MIN) {
>  		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);
>  		int troom = skb->tail + skb->data_len - skb->end;
>  

IIUC the initial purpose of SKB mode was to be able to test or
experiment with XDP "until drivers add support". If that's still
the case the semantics of XDP SKB should be as close to ideal
XDP implementation as possible.

We had a knob for specifying needed headroom, is that thing not 
working / not a potentially cleaner direction?
