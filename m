Return-Path: <netdev+bounces-3561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D89A0707DF5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5890F28148F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EEF125A0;
	Thu, 18 May 2023 10:24:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472CB11C91
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:24:56 +0000 (UTC)
Received: from r3-11.sinamail.sina.com.cn (r3-11.sinamail.sina.com.cn [202.108.3.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247D11BD3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:24:53 -0700 (PDT)
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([112.97.61.162])
	by sina.com (172.16.97.27) with ESMTP
	id 6465FCF000005E14; Thu, 18 May 2023 18:24:51 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 73519787031
From: Hillf Danton <hdanton@sina.com>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Vallo <kvalo@kernel.org>,
	syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH v3 1/2] wifi: ath9k: fix races between ath9k_wmi_cmd and ath9k_wmi_ctrl_rx
Date: Thu, 18 May 2023 18:24:37 +0800
Message-Id: <20230518102437.4443-1-hdanton@sina.com>
In-Reply-To: <20230426190206.ni2au5mpjc5oty67@fpc>
References: <20230425192607.18015-1-pchelkin@ispras.ru> <20230425230708.2132-1-hdanton@sina.com> <20230426190206.ni2au5mpjc5oty67@fpc>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> On Wed, Apr 26, 2023 at 07:07:08AM +0800, Hillf Danton wrote: 
>> Given similar wait timeout[1], just taking lock on the waiter side is not
>> enough wrt fixing the race, because in case job done on the waker side,
>> waiter needs to wait again after timeout.
>> 
>
> As I understand you correctly, you mean the case when a timeout occurs
> during ath9k_wmi_ctrl_rx() callback execution. I suppose if a timeout has
> occurred on a waiter's side, it should return immediately and doesn't have
> to care in which state the callback has been at that moment.
>
> AFAICS, this is controlled properly with taking a wmi_lock on waiter and
> waker sides, and there is no data corruption.
>
> If a callback has not managed to do its work entirely (performing a
> completion and subsequently waking waiting thread is included here), then,
> well, it is considered a timeout, in my opinion.
>
> Your suggestion makes a wmi_cmd call to give a little more chance for the
> belated callback to complete (although timeout has actually expired). That
> is probably good, but increasing a timeout value makes that job, too. I
> don't think it makes any sense on real hardware.
>
> Or do you mean there is data corruption that is properly fixed with your patch?

Given complete() not paired with wait_for_completion(), what is the
difference after this patch?

