Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD60A1DA953
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgETEgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgETEgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:36:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28DDC061A0F
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:36:42 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z26so949623pfk.12
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z18eUcX9wumqAi1dZD97mqpztrpNBRW0eHw97u6ixxM=;
        b=hnmvyk/M83EsgHOqYGveBP5/xO9sKSMWadm584PNwZy+/Oph7HoRx8Ln2sEpjLU5qw
         xOWTiT2CEAUODRkg1aJNaUdrmEp3/fYLwuouPPQWxotBxYF6+pHp7Cvl3nkJxxLjT9JZ
         abO018U4u4MauIzN8h07kT81+XaoZl/+wOQAtMHPMqQ38OmBmBVRZCnDzPPl4vZxll9+
         urzIGK9Rx0rocxi/lsOK5HoPZbjGFO2mAyAhr8EvTdewc9sWCs6MgBNsfv2ZQT6/c4qk
         EEdgKI4X3/EtLJO7fnn/a/+meJ7+T5jaU8pNhnU02fr94zN+/I4ID5W6KR0y1fSmcawM
         sxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z18eUcX9wumqAi1dZD97mqpztrpNBRW0eHw97u6ixxM=;
        b=Pf66VmZrm/RK0PxHeTVBuM5Mz/1VWQUw3ChPu0pgsqSV+1WlpqifLa8CuMhq1ZcF3b
         aHZvp5DgZo6ZQVVCBX+1ZSB2nR2FrLScWPjWDRKStgHZka2CNyI4zFLHsBGV+wix/K2h
         gisB45U0whA3Gu4U+21cBG7Yn+X0ZBRn4GenwUQMExCZP1RxZBgpCsAJYyQ3weC/n/XX
         VSkynFjh1WE0eCbMsSulQdS5TC6+hm5vchjiNwfzCfED/cnmf0L2pi7gLZbWEeXxUc6u
         w/URShI0IrGXmgE4pj6kl8zZxKQaPm7yaugBgANb2JCyqhSi+F0A5D5MxFGvjkZ3FUaW
         Q/Vw==
X-Gm-Message-State: AOAM533aBlBEqWSh9B6uwczvnZ3TkidAMKaJG895R0NP+W8H/uvRRB80
        BgIMd4K2Czy29/jOyow44hC5yw==
X-Google-Smtp-Source: ABdhPJwtRqanuNy5NN42n7ANp36PIBW5Zrc+UW5lghh91ZKUrjlYos3E7Sj4Rg2hzERL1tJEpETFaw==
X-Received: by 2002:a62:7996:: with SMTP id u144mr2368896pfc.86.1589949402274;
        Tue, 19 May 2020 21:36:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y10sm876007pfb.53.2020.05.19.21.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 21:36:41 -0700 (PDT)
Date:   Tue, 19 May 2020 21:36:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>, tglx@linutronix.de,
        a.darwish@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        will@kernel.org, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200519213637.4d874aad@hermes.lan>
In-Reply-To: <886041df-d889-3d88-59fe-e190d15f9c98@gmail.com>
References: <87v9kr5zt7.fsf@nanos.tec.linutronix.de>
        <20200519161141.5fbab730@hermes.lan>
        <87lfln5w61.fsf@nanos.tec.linutronix.de>
        <20200519.195722.1091264300612213554.davem@davemloft.net>
        <886041df-d889-3d88-59fe-e190d15f9c98@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 20:18:19 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On 5/19/20 7:57 PM, David Miller wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Wed, 20 May 2020 01:42:30 +0200
> >   
> >> Stephen Hemminger <stephen@networkplumber.org> writes:  
> >>> On Wed, 20 May 2020 00:23:48 +0200
> >>> Thomas Gleixner <tglx@linutronix.de> wrote:  
> >>>> No. We did not. -ENOTESTCASE  
> >>>
> >>> Please try, it isn't that hard..
> >>>
> >>> # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
> >>>
> >>> real	0m17.002s
> >>> user	0m1.064s
> >>> sys	0m0.375s  
> >>
> >> And that solves the incorrectness of the current code in which way?  
> > 
> > You mentioned that there wasn't a test case, he gave you one to try.
> >   
> 
> I do not think this would ever use device rename, nor netdev_get_name()
> 
> None of this stuff is fast path really.
> 
> # time for ((i=1;i<1000;i++)); do ip li add dev dummy$i type dummy; done
> 
> real	0m1.127s
> user	0m0.270s
> sys	0m1.039s

Your right it is a weak test, and most of the overhead is in the syscall
and all netlink events that happen.

It does end up looking up the new name, so would exercise that.
Better test is to use %d syntax or create 1000 dummy's then rename every one.

This is more of a stress test
# for ((i=0;i<1000;i++)); do echo link add dev dummy%d type dummy; done | time ip -batch -
0.00user 0.29system 0:02.11elapsed 13%CPU (0avgtext+0avgdata 2544maxresident)k
0inputs+0outputs (0major+148minor)pagefaults 0swaps

# for ((i=999;i>=0;i--)); do echo link set dummy$i name dummy$((i+1)); done | time ip -batch -
0.00user 0.26system 0:54.98elapsed 0%CPU (0avgtext+0avgdata 2508maxresident)k
0inputs+0outputs (0major+145minor)pagefaults 0swaps

