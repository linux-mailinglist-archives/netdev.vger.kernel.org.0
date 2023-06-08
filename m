Return-Path: <netdev+bounces-9326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E74872872C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5E751C2103B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F76C1EA98;
	Thu,  8 Jun 2023 18:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4444919930
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:28:43 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE52210C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:28:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q7KN5-0002e7-7y; Thu, 08 Jun 2023 20:28:31 +0200
Date: Thu, 8 Jun 2023 20:28:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	pabeni@redhat.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net v2 3/3] net/sched: act_ipt: zero skb->cb before
 calling target
Message-ID: <20230608182831.GE27126@breakpoint.cc>
References: <20230608140246.15190-1-fw@strlen.de>
 <20230608140246.15190-4-fw@strlen.de>
 <CAM0EoMkMxOwxNVANaYjd6GBFOkkhkNz=n9xyTnLR6=OmB9nVAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMkMxOwxNVANaYjd6GBFOkkhkNz=n9xyTnLR6=OmB9nVAw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On Thu, Jun 8, 2023 at 10:03 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > xtables relies on skb being owned by ip stack, i.e. with ipv4
> > check in place skb->cb is supposed to be IPCB.
> >
> > I don't see an immediate problem (REJECT target cannot be used anymore
> > now that PRE/POSTROUTING hook validation has been fixed), but better be
> > safe than sorry.
> >
> > A much better patch would be to either mark act_ipt as
> > "depends on BROKEN" or remove it altogether. I plan to do this
> > for -next in the near future.
> 
> Let me handle this part please.

Sure, no problem.

> > This tc extension is broken in the sense that tc lacks an
> > equivalent of NF_STOLEN verdict.
> > With NF_STOLEN, target function takes complete ownership of skb, caller
> > cannot dereference it anymore.
> >
> > ACT_STOLEN cannot be used for this: it has a different meaning, caller
> > is allowed to dereference the skb.
> >
> 
> ACT_STOLEN requires that the target clones the packet and the caller
> to free the skb.

Makes sense, but if NF_STOLEN gets returned the skb is already released,
so we can't touch it anymore.

> > At this time NF_STOLEN won't be returned by any targets as far as I can
> > see, but this may change in the future.
> >
> > It might be possible to work around this via list of allowed
> > target extensions known to only return DROP or ACCEPT verdicts, but this
> > is error prone/fragile.
> 
> I didnt quiet follow why ACT_STOLEN if this action frees the packet
> and returns NF_STOLEN

We could emulate NF_STOLEN via ACT_STOLEN, yes, but we'd have to
skb_clone() unconditionally for every skb before calling the target
eval function...

Other alternatives I can think of:

- keep a list of "known safe" targets,
- annotate all accept-or-drop targets as "safe for act_ipt"
- make the skb shared before calling target function
- ensure that targets will never ever return NF_STOLEN

I dont really like any of these options :-)

At this time, targets return one of accept/drop/queue.

NF_QEUEUE will log an error and treats it like NF_ACCEPT,
so we are good at this time.

