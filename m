Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9779E5E6264
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiIVM3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiIVM3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C5BE512A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 05:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B2F601D0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38126C433C1;
        Thu, 22 Sep 2022 12:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663849749;
        bh=MULFj6+yJvV/Sng3l9Is5AkxaSfAmsQmBn7I2yFYkdY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b+HcGU5EHzuzhWl9BrR3zbx4hVnXoPeuvADctoe6qpX7WYQpuD6isgsBWeGRNNy9s
         fC1KB68HxLnIsxm1Z85ZIyLOdSwOwUFLRkiBe4R8lOjSYNfmeYYiJtUoUqWWh+Ex7T
         Dy0B/OgOfm23hl7lTuLrTgKx02BB/2YYP09sVXuNWLDSQivz+VuMBcvXI69V4wP1Fa
         F8vQupv0+wyhf3rjm8UbNl737W2Fl7Y1EE6ZgbEq113lBl7RYHar+B3qhyWUZpKlQO
         +8zvL8uqDPRTXbpTEbIkD1b2Ei49VUljNV1uedmDYKvMabBmr18fCgYbmWOoQGEqVx
         nOdDJ/g3g2svA==
Date:   Thu, 22 Sep 2022 05:29:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Message-ID: <20220922052908.4b5197d9@kernel.org>
In-Reply-To: <MWHPR11MB1293C87E3EC9BD7D64829F2FF14E9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
        <20220921132929.3f4ca04d@kernel.org>
        <MWHPR11MB1293C87E3EC9BD7D64829F2FF14E9@MWHPR11MB1293.namprd11.prod.outlook.com>
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

On Thu, 22 Sep 2022 08:19:07 +0000 Nambiar, Amritha wrote:
> > Alex pointed out that it'd be worth documenting the priorities of
> > aRFS vs this thing, which one will be used if HW matches both.  
> 
> Sure, I will document the priorities of aRFS and TC filter selecting
> the Rx queue. On Intel E810 devices, the TC filter selecting Rx queue
> has higher priority over aRFS (Flow director filter) if both the filters
> are matched.

Is it configurable? :S If we think about RSS context selection we'd
expect the context to be selected based on for example the IPv6 daddr 
of the container but we still want aRFS to select the exact queue...
Is there a counterargument for giving the flow director higher prio?
