Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB57564242
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiGBTBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiGBTBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:01:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B965463E5;
        Sat,  2 Jul 2022 12:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B4B9B80882;
        Sat,  2 Jul 2022 19:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18AFC34114;
        Sat,  2 Jul 2022 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788470;
        bh=HnMLOMngzYmCfv9EoA0IJZhKk3NgHhd9m1LNgCBIWS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NgaX6wCFSwp+Ev/pL19Xb7/YByiLCukMuQAUwJVLOtjvQBUUE+xOHCj1/UgJ/0uaN
         QvjPByZv8zCljFvQk6+YQCyBD3jAZAdQQyKAdHdD+xrwsOmxboUf6/4he2yYCBGTPP
         1wYKW0OS7+X6hqWQMSSeex38CEBdbtsq6ojiZdZN/kPFkyRu3KcmtpnhuG2RuY8MRd
         MB0lMhtMV9r3Yusv8Kqw7biNmmP9zSnecxvQZ2KsurVZWKpn1NwemPaysET5t1GFI4
         sl02Zl97IVj+s5JjGZqGDgGSvD1U+QGiXD6Ot0Q/jATK+tn9G2pG9n8MHHqK3Tou2c
         T2xFVllkI8M/Q==
Date:   Sat, 2 Jul 2022 12:01:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     duoming@zju.edu.cn
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH v4] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
Message-ID: <20220702120108.32985427@kernel.org>
In-Reply-To: <1bbd2137.23c51.181bdcb792f.Coremail.duoming@zju.edu.cn>
References: <20220629104941.26351-1-duoming@zju.edu.cn>
        <20220701194155.5bd61e58@kernel.org>
        <1bbd2137.23c51.181bdcb792f.Coremail.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Jul 2022 15:23:57 +0800 (GMT+08:00) duoming@zju.edu.cn wrote:
> > On Wed, 29 Jun 2022 18:49:41 +0800 Duoming Zhou wrote:  
> > > When the link layer connection is broken, the rose->neighbour is
> > > set to null. But rose->neighbour could be used by rose_connection()
> > > and rose_release() later, because there is no synchronization among
> > > them. As a result, the null-ptr-deref bugs will happen.
> > > 
> > > One of the null-ptr-deref bugs is shown below:
> > > 
> > >     (thread 1)                  |        (thread 2)
> > >                                 |  rose_connect
> > > rose_kill_by_neigh              |    lock_sock(sk)
> > >   spin_lock_bh(&rose_list_lock) |    if (!rose->neighbour)
> > >   rose->neighbour = NULL;//(1)  |
> > >                                 |    rose->neighbour->use++;//(2)  
> >   
> > >  		if (rose->neighbour == neigh) {  
> > 
> > Why is it okay to perform this comparison without the socket lock,
> > if we need a socket lock to clear it? Looks like rose_kill_by_neigh()
> > is not guaranteed to clear all the uses of a neighbor.  
> 
> I am sorry, the comparision should also be protected with socket lock.
> The rose_kill_by_neigh() only clear the neighbor that is passed as
> parameter of rose_kill_by_neigh(). 

Don't think that's possible, you'd have to drop the neigh lock every
time.

> > > +			sock_hold(s);
> > > +			spin_unlock_bh(&rose_list_lock);
> > > +			lock_sock(s);
> > >  			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
> > >  			rose->neighbour->use--;  
> > 
> > What protects the use counter?  
> 
> The use coounter is protected by socket lock.

Which one, the neigh object can be shared by multiple sockets, no?
