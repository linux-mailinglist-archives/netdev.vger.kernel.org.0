Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A9B5175AC
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386636AbiEBRXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378055AbiEBRXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:23:05 -0400
Received: from relay5.hostedemail.com (relay5.hostedemail.com [64.99.140.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E6A1B4
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 10:19:36 -0700 (PDT)
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id CB9312A109;
        Mon,  2 May 2022 17:19:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 83B342000D;
        Mon,  2 May 2022 17:19:33 +0000 (UTC)
Message-ID: <56e0b30632826dda7db247bd5b6e4bb28245eaa7.camel@perches.com>
Subject: Re: [net-next PATCH] amt: Use BIT macros instead of open codes
From:   Joe Perches <joe@perches.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Juhee Kang <claudiajkang@gmail.com>, ap420073@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date:   Mon, 02 May 2022 10:19:32 -0700
In-Reply-To: <4320a4cb3e826335db51a6fac49053dbd386f119.camel@redhat.com>
References: <20220430135622.103683-1-claudiajkang@gmail.com>
         <4320a4cb3e826335db51a6fac49053dbd386f119.camel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 83B342000D
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Stat-Signature: 5hb8c3nieui1zz8mrq67gswoqrsb79um
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+nF2xcoR3VH1PgG72bot9vRJnx+JP1JYg=
X-HE-Tag: 1651511973-398330
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-02 at 12:11 +0200, Paolo Abeni wrote:
> On Sat, 2022-04-30 at 13:56 +0000, Juhee Kang wrote:
> > Replace open code related to bit operation with BIT macros, which kernel
> > provided. This patch provides no functional change.
[]
> > diff --git a/drivers/net/amt.c b/drivers/net/amt.c
[]
> > @@ -959,7 +959,7 @@ static void amt_req_work(struct work_struct *work)
> >  	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
> >  	spin_lock_bh(&amt->lock);
> >  out:
> > -	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
> > +	exp = min_t(u32, (1 * BIT(amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
> >  	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
> >  	spin_unlock_bh(&amt->lock);
> >  }
> > diff --git a/include/net/amt.h b/include/net/amt.h
[]
> > @@ -354,7 +354,7 @@ struct amt_dev {
> >  #define AMT_MAX_GROUP		32
> >  #define AMT_MAX_SOURCE		128
> >  #define AMT_HSIZE_SHIFT		8
> > -#define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
> > +#define AMT_HSIZE		BIT(AMT_HSIZE_SHIFT)
> >  
> >  #define AMT_DISCOVERY_TIMEOUT	5000
> >  #define AMT_INIT_REQ_TIMEOUT	1
> 
> Even if the 2 replaced statements use shift operations, they do not
> look like bit manipulation: the first one is an exponential timeout,
> the 2nd one is an (hash) size. I think using the BIT() macro here will
> be confusing.

I agree.

I also believe one of the uses of amt->req_cnt is error prone.

	drivers/net/amt.c:946:  if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {

Combining a test and post increment is not a great style IMO.
Is this really the intended behavior?


