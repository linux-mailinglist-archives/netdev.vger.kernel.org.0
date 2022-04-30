Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A581515949
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 02:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbiD3AUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 20:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiD3AUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 20:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BCF8023A
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 17:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6E2B835E5
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 00:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF76BC385A7;
        Sat, 30 Apr 2022 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651277839;
        bh=Fbf8zIT44xl4kJOJB8OePM2faE3YTHAmvePGg1RbM9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GjXrM19G+G+K9HzQmoD8EXcmcWmeU9Zr6yjxbowIR55oiyHZk4oP9koE5+4hfG3J2
         Jmm2jf/o9BZA8kSjlQ9TE2g1Ve1bb8KAqEKHf0GDSc2b9i/ISO6/PvbG0pAvVnDJUs
         eBCGKPBAqtRlysnEt9fkqc84inkDS+0nJTBOjl2mOTmIeipMsB7dy9n00aBLu9SUBJ
         TEspZbFE6aP+puNd3H8X3cIYJJ8yFZQZ3eNONZu+4HdF9cdiIiffmNBUhiQGrPnQKm
         jFjw8irgxHkS40807+6gHp6A/fdb2K8U5UpYHPeXTgSnnvkBuLlt8LdikaU8/x9OJy
         W5qTGY6/n36Xg==
Date:   Fri, 29 Apr 2022 17:17:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Message-ID: <20220429171717.5b0b2a81@kernel.org>
In-Reply-To: <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
        <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
        <20220428160414.28990a0c@kernel.org>
        <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URI_NO_WWW_INFO_CGI autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 23:43:06 +0000 Nambiar, Amritha wrote:
> > > HW.
> > > Example:
> > > $ tc filter add dev ens4f0 protocol ip ingress flower\
> > >   dst_ip 192.168.1.12 ip_proto tcp dst_port 5001\
> > >   skip_sw classid ffff:0x5
> > >
> > > The above command adds an ingress filter, the accepted packets
> > > will be directed to queue 4. The major number represents the ingress  
> > 
> > ..and "directed" here. TC is used for so many different things you
> > really need to explain what your use case is.
> >   
> 
> Sorry about using the terms "forward" and "direct" interchangeably in this
> context. I should have been more consistent with the terminology. 
> 
> The use case is to accept incoming packets into a queue via TC ingress filter.
> TC filters are offloaded to a hardware table called the "switch" table. This
> table supports two types of actions in hardware termed as "forward to queue" and 
> "forward to a VSI aka queue-group". Accepting packets into a queue using
> ethtool filter is also supported, but this type of filter is added into a 
> different hardware table called the "flow director" table. The flow director
> table has certain restrictions that it can only have filters with the same packet
> type. The switch table does not have this restriction.
> 
> > > qdisc. The general rule is "classID's minor number - 1" upto max
> > > queues supported. The queue number is in hex format.  
> > 
> > The "general rule" you speak of is a rule you'd like to establish,
> > or an existing rule?  
> 
> This is an existing rule already being used in the TX qdiscs. We are using
> this in the ingress qdisc and offloading RX filters following the explanation
> from Netdev 0x13 session presented by Jamal. Section 4.1 from
> https://legacy.netdevconf.info/0x13/session.html?talk-tc-u-classifier
> "There is one interesting tidbit on the above rule exposed
> via the "classid 1:1" construct: the accepted packets will be
> queued to DMA ring 0. If classid 1:2 was used then they
> would be queued to DMA ring 1 etc. The general rule is the
> "classid's minor number - 1" upto a max of DMA queues
> supported by the NIC (64 in the case of the ixgbe). By definition, this is
> how tc classids are intended to be used i.e they select queues (in this
> case hardware ingress queues)."

So we're faking mqprio behavior on ingress? I guess that's fine.

Wouldn't SKBEDIT_F_QUEUE_MAPPING be a more natural fit here?
