Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B3954B59C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbiFNQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiFNQOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:14:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99EE381A3
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 646DDB81990
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 16:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3191C3411B;
        Tue, 14 Jun 2022 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655223280;
        bh=myct3deyPVYprBsBvmvk334jKipt3T/7mIRJOSx3Ffk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ofzZKpB6KluJ/x+qfzJyY4IJGl1tjrjcv2ggMVJFka1nX3dpSaeSIUHVXcY/EkXgG
         6NygnHd3euOWZxzhb0KL/+hoWNEDl7zebDLYW4rbKiD+6GzuRBhbvbLqOXr7h769I2
         4v5YEHEq+CDkPrb21Y1exWzItIrey3KSy1yhzU9HPIH5iRTYHoIBqgpCS8MHkDa6iW
         EP0xLHwwXd8zES954TWPdbaGGxbA41djrl264pC/V91StCbH8SrM8dP/plz2dCBbTI
         jFYEdVJQgFG/Rt3ev7URilGwQ2ietPZX3um8wXL1bwW5iP/8howiIdnqYhUZXz5i6+
         067aTyCSbC2Hw==
Date:   Tue, 14 Jun 2022 09:14:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lior Nahmanson <liorna@nvidia.com>, edumazet@google.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Message-ID: <20220614091438.3d0665d9@kernel.org>
In-Reply-To: <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 15:55:13 +0200 Paolo Abeni wrote:
> The main reason I suggested to look for the a possible alternative to
> the skb extension is that the GRO stage is becoming bigger (and slower)
> with any of such addition.
> 
> The 'slow_gro' protects the common use-case from any additional
> conditionals and intructions, I still have some concerns due to the
> increased code size.
> 
> This is not a reject, I'm mostly looking for a 2nd opinion.

Shooting from the hip a little bit, but macsec being a tightly bound L2
upper maybe metadata dst is a workable solution for carrying the sci and
offload status between upper and lower? The range of values should be
well known and limited. 
