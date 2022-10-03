Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7685F36CE
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 22:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJCUBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 16:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJCUBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 16:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC8D3A154
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 13:01:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25508611A8
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 20:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2FFC433C1;
        Mon,  3 Oct 2022 20:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664827310;
        bh=7caq6m8EYs5UPGQDZxC/9xGH3++P7bJwbFrplvrPnWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QAmN+LIC/9peydFbDZnsdreCqu0i+fOsO4iLv2SX1qXbSlwwbXJTIWiD5Mnwjv+AS
         FF/x8VKsLiWDQoy8rHKpJOv7hod/ZoVEUPCpWMRZ/cdNgroWMEJ9qQY9XWENRH9i/5
         7OAWuzuHLILA1C87GLXYsYLwl3n4my8C+Dtqg8ZNpVBpqDc0Ei7VOgW7yGJIXh997A
         g4QbdADGhAHr79lh4NMQGvBeZflbs5CqIFf16L+uIYHAeq6STby+gM3wws0Z4LUXSa
         pRcUSTzi23rkKoQ9XM4ZI/DaY7rGPQRh87MBTybAYvzbKuMI7+WBtaGOFqtZLCq0yM
         FB+zEhOMkBLWQ==
Date:   Mon, 3 Oct 2022 13:01:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next v2 0/5] nfp: support FEC mode reporting and
 auto-neg
Message-ID: <20221003130149.07f38aaf@kernel.org>
In-Reply-To: <20221003084111.GA39850@nj-rack01-04.nji.corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
        <20220930184735.62aa0781@kernel.org>
        <20221003084111.GA39850@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 16:41:11 +0800 Yinjun Zhang wrote:
> > Looks better, thanks for the changes.
> > 
> > BTW shouldn't the sp_indiff symbol be prefixed by _pf%u ?
> > That's not really introduced by this series tho.  
> 
> Thanks for your advice. Although sp_indiff is exposed by per-PF rtsym
> _pf%u_net_app_cap, which can be used for per-PF capabilities in future,
> I think sp_indiff won't be inconsistent among PFs. We'll adjust it if
> it happens.

It's not about inconsistencies but about the fact that in multi-host
systems there are multiple driver instances which come and go.
The driver seems to set sp_indiff to one at load and to zero when it
unloads. IDK what that actually does to the FW but if it does anything
it's not gonna work reliably in MH.
