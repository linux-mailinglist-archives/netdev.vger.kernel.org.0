Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8602528CB5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbiEPSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344706AbiEPSQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:16:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C147A63B2
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78F61B815A3
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CECC385AA;
        Mon, 16 May 2022 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652724956;
        bh=zZX1rlQQV6qtcmBc8639KoMvPiB1MVOQOPwTyrsIV2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=am6sz3g5cyf1iHcnT7+G41am7F5C21DHfKlQtuRiPd+9da6ttTskAKMboI+VnVINT
         9PGhonmGM3r1ziTmdpAjg68VzRzprvldWuyp83fSl4VuLQap2tZ/L/IBgKewJeQEMG
         Ry2lDCz+nH460yePW3U9H0KISwQzuGVwBlS9AVGm1paJSnM/1MdiWKuMDLnOvOcEw+
         cBlAMJwy90ckTekYgR3QljWfbyoCQGYOx737kkul0MxObLqinIv2gY763kY9S5SORD
         iHl5W2cvCMMPDQBaQYRIQe8TycdzwGP0GESadJgi9knLY015qoKNYI9kKgG9ifxcqB
         KCTb1HSPZyC8w==
Date:   Mon, 16 May 2022 11:15:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/4] net: fix possible race in
 skb_attempt_defer_free()
Message-ID: <20220516111554.5585a6b5@kernel.org>
In-Reply-To: <20220516042456.3014395-2-eric.dumazet@gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
        <20220516042456.3014395-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 May 2022 21:24:53 -0700 Eric Dumazet wrote:
> A cpu can observe sd->defer_count reaching 128,
> and call smp_call_function_single_async()
> 
> Problem is that the remote CPU can clear sd->defer_count
> before the IPI is run/acknowledged.
> 
> Other cpus can queue more packets and also decide
> to call smp_call_function_single_async() while the pending
> IPI was not yet delivered.
> 
> This is a common issue with smp_call_function_single_async().
> Callers must ensure correct synchronization and serialization.
> 
> I triggered this issue while experimenting smaller threshold.
> Performing the call to smp_call_function_single_async()
> under sd->defer_lock protection did not solve the problem.
> 
> Commit 5a18ceca6350 ("smp: Allow smp_call_function_single_async()
> to insert locked csd") replaced an informative WARN_ON_ONCE()
> with a return of -EBUSY, which is often ignored.
> Test of CSD_FLAG_LOCK presence is racy anyway.

If I'm reading this right this is useful for backports but in net-next
it really is a noop? The -EBUSY would be perfectly safe to ignore?
Just checking.
