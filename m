Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B0F5188FD
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbiECPvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbiECPvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:51:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3B233EAE
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 08:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCCA3B81D9A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 15:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0AC385A9;
        Tue,  3 May 2022 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651592854;
        bh=pVGCj+DxgYTU+DuwKO1EGVl0o/pIUARk29fRsVl3qac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sJ1f1knv8mj1e7UDgK30NrhGc2a0qu8bMJEwGKAW++w9PgitEgBii/Y/81aRr/22g
         8rJL6MbQlXJtJCw7i+RoLYuje96fHfP0EV5iQVfBek6fPXGbAjcRlT2vsAAoCexI4P
         ezCK+SxudPMYfXFixNusLYf/LA8sVn9KS00kvO5PQw6dYA71hzceA9c60nNklifBSE
         bGmQRzKhYjQAuu2YMmk5turEKJRrAr2TMst3HPRhltNMiuz5PctyOUiMSTA3IbxV+L
         +ATPBXckoKGSkFZPHkrUvIArbVQaNxYB39TcNl8gFpiwKGdK4tIona0XeP4Dhk33l/
         NpfQPj4fsG10Q==
Date:   Tue, 3 May 2022 08:47:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     "Nambiar, Amritha" <amritha.nambiar@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Message-ID: <20220503084732.363b89cc@kernel.org>
In-Reply-To: <d3935370-b12c-e9db-1e59-52c8cceacf9a@mojatatu.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
        <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
        <20220428160414.28990a0c@kernel.org>
        <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
        <20220429171717.5b0b2a81@kernel.org>
        <MWHPR11MB129308C755FAB7B4EA1F8DDCF1FF9@MWHPR11MB1293.namprd11.prod.outlook.com>
        <20220429194207.3f17bf96@kernel.org>
        <d3935370-b12c-e9db-1e59-52c8cceacf9a@mojatatu.com>
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

On Tue, 3 May 2022 06:32:01 -0400 Jamal Hadi Salim wrote:
> I am on the fence of "six of one, half a dozen of the other" ;->
> 
> TC classids have *always been used to identify queues* (or hierarchy of
> but always leading to a single queue). Essentially a classid identity
> is equivalent to a built-in action which says which queue to pick.
> The data structure is very much engrained in the tc psyche.
> 
> When TX side HW queues(IIRC, mqprio) showed up there was ambiguity to
> distinguish between a s/w queue vs a h/w queue hence queue_mapping
> which allows us to override the *HW TX queue* selection - or at least
> that was the intended goal.
> Note: There are other ways to tell the h/w what queues to use on TX
> (eg skb->priority) i.e there's no monopoly by queue_mapping.
> 
> Given lack of s/w queues on RX (hence lack of ambiguity) it seemed
> natural that the classid could be used to describe the RX queue
> identity for offload, it's just there.
> I thought it was brilliant when Amritha first posted.

Is it just me or is TC generally considered highly confusing?
IMO using a qdisc cls construct in clsact is only going to add 
to that.

Assigning classid can still be meaningful on ingress in case 
of a switch where there are actual qdiscs offloaded.

> I think we should pick the simpler of "half-dozen or six".
> The posted patch seems driver-only change i.e no core code
> changes required (which other vendors could follow).
> But i am not sure if that defines "simpler".

No core changes is not an argument we should take seriously upstream.

> BTW:
> Didnt follow the skb_record_rx_queue() thought - isnt that
> always set by the driver based on which h/w queue the packet
> arrived at? Whereas the semantics of this is to tell the h/w
> what queue to use.

Overriding the queue mapping in the SW could still be useful 
if TC wants to override the actual queue ID assigned by the NIC.

This way whether the action gets offloaded or not the resulting
skb will have the same metadata (in case of offload because it 
came on the right queue and the driver set the mapping, in case
of sw because we overwrote the mapping).
