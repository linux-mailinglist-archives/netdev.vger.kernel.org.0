Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D525D51A416
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiEDPhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236890AbiEDPhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:37:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE39443F8
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C140B826E0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7F3C385A5;
        Wed,  4 May 2022 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651678416;
        bh=7uhZxm+A/sRm+aC5Zd4aA9MiSCvNtDUpdxPH3zxeV38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKYdHGPcTeBptqk0nLYEEk8w9Fcj822uxpuoCDDzp9R8MbYICIyENRtr/E/oRiM8k
         iJHZ0CtXwBptRfPPp9mqc5oCUdq5nfMI5pk96c1KRRKS4cq1MMqkE5TIwh8x2p1xJ2
         ZM39T6BUY8o/w/V99Htuo9hjb7SCrN4wBangydpbNEd6CZPJmx2vRDHKxS8ch+lvGS
         GoxQFWgur8FvHYLWKHzKKoRn/UJiwiF1lmbRK+bk6ip7ThO5ZS91Jh2F4lQUo7v+wo
         Acj0KWmWhF7tLuJ9HcaVCrWU0Ufi473s7jXkKnPdBU7YJYaebYrF/9MQ5VtZM8kxc3
         z4USDmZqY1nYw==
Date:   Wed, 4 May 2022 08:33:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
Message-ID: <20220504083334.1b7a98e3@kernel.org>
In-Reply-To: <a8abc239076eb96ed88680dab1a1abe50a5dac7b.camel@redhat.com>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
        <7e4682da-6ed6-17cf-8e5a-dff7925aef1d@mojatatu.com>
        <cac58f4ead1cac145d5a2005bcd3556851807f86.camel@redhat.com>
        <20220504074718.146a5724@kernel.org>
        <a8abc239076eb96ed88680dab1a1abe50a5dac7b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 May 2022 17:11:25 +0200 Paolo Abeni wrote:
> > For testing stuff like this would it be possible to inject packets
> > with no headers pulled and frags in pages we marked read-only?
> > We can teach netdevsim to do it.  
> 
> We additionally need to ensure that the crafted packets are cloned,
> otherwise the current code is AFAICS fine.

Depends whether skb frags are writable, or not. Or to put it differently
why does skb_cow_data() exist and does what it does.
