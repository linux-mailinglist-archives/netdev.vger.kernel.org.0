Return-Path: <netdev+bounces-1591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C49A06FE662
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF41B1C20E1E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B9B1D2DE;
	Wed, 10 May 2023 21:43:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F8721CDF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:43:53 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BBE46A9;
	Wed, 10 May 2023 14:43:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1pwrb0-0002Ud-Bp; Wed, 10 May 2023 23:43:38 +0200
Date: Wed, 10 May 2023 23:43:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Lee Jones <lee@kernel.org>, Sebastian Reichel <sre@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, linux-leds@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: Re: [PATCH RESEND 1/4] leds: Change led_trigger_blink[_oneshot]()
 delay parameters to pass-by-value
Message-ID: <20230510214338.GE21949@breakpoint.cc>
References: <20230510162234.291439-1-hdegoede@redhat.com>
 <20230510162234.291439-2-hdegoede@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510162234.291439-2-hdegoede@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hans de Goede <hdegoede@redhat.com> wrote:
> led_blink_set[_oneshot]()'s delay_on and delay_off function parameters
> are pass by reference, so that hw-blink implementations can report
> back the actual achieved delays when the values have been rounded
> to something the hw supports.
> 
> This is really only interesting for the sysfs API / the timer trigger.
> Other triggers don't really care about this and none of the callers of
> led_trigger_blink[_oneshot]() do anything with the returned delay values.
> 
> Change the led_trigger_blink[_oneshot]() delay parameters to pass-by-value,
> there are 2 reasons for this:
> 
> 1. led_cdev->blink_set() may sleep, while led_trigger_blink() may not.
> So on hw where led_cdev->blink_set() sleeps the call needs to be deferred
> to a workqueue, in which case the actual achieved delays are unknown
> (this is a preparation patch for the deferring).
> 
> 2. Since the callers don't care about the actual achieved delays, allowing
> callers to directly pass a value leads to simpler code for most callers.

For netfilter:

Acked-by: Florian Westphal <fw@strlen.de>

