Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86D1E153
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfD2Lan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:30:43 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:60432 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbfD2Lan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 07:30:43 -0400
Received: by mail.osadl.at (Postfix, from userid 1001)
        id BAE5D5C0B38; Mon, 29 Apr 2019 13:29:50 +0200 (CEST)
Date:   Mon, 29 Apr 2019 13:29:50 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Nicholas Mc Guire <hofrat@osadl.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net_sched: force endianness annotation
Message-ID: <20190429112950.GB17830@osadl.at>
References: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
 <07d36e94-aad4-a263-bf09-705ee1dd59ed@solarflare.com>
 <20190429104414.GB17493@osadl.at>
 <eb4449ae-70db-c487-9c47-301225734943@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb4449ae-70db-c487-9c47-301225734943@solarflare.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 12:11:18PM +0100, Edward Cree wrote:
> On 29/04/2019 11:44, Nicholas Mc Guire wrote:
> > be16_to_cpu((__force __be16)val) should be a NOP on big-endian as well
> Yes.  But it's semiotically wrong to call be16_to_cpu() on a cpu-endian
>  value; if the existing behaviour is desired, it ought to be implemented
>  differently.
> > The problem with using swab16 is that it is impating the binary significantly
> > so I'm not sure if the change is really side-effect free
> It's not; it changes the behaviour.  That's why I brought up the question
>  of the intended behaviour ??? it's unclear whether the current (no-op on BE)
>  behaviour is correct or whether it's a bug in the original code.
> Better to leave the sparse error in place ??? drawing future developers'
>  attention to something being possibly wrong here ??? than to mask it with a
>  synthetic 'fix' which we don't even know if it's correct or not.
> 
> > but I just am unsure if
> > -                   val = be16_to_cpu(val);
> > +                   val = swab16(val);
> > is actually equivalent.
> If you're not sure about such things, maybe you shouldn't be touching
>  endianness-related code.  swab is *not* a no-op, either on BE or LE.

Well the only way to understand it is to try to understand it by reviewing
the implementatoins - which is whyt I'm currently doing - the principle 
issues are clear I think - following the details of the macro-chains is
not always that clear. From looking at the code history it does seem correct
which is why it seemed reasonable to remove the sparse warning and doing
so with a patch that does not change the binary seems the safest.

thx!
hofrat
