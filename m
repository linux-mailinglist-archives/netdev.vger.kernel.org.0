Return-Path: <netdev+bounces-978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DAC26FBAFD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 00:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 217492810F5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C25125D2;
	Mon,  8 May 2023 22:24:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D72DDAA
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 22:24:29 +0000 (UTC)
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151BF5B92;
	Mon,  8 May 2023 15:24:28 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-38e04d1b2b4so2648340b6e.3;
        Mon, 08 May 2023 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683584667; x=1686176667;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GqRriGRUbsesORv9FIQ/f84+f/Gs1+ORAutqa65QH14=;
        b=E7+nTuciqBm47StC0rsNq9xDODx9s6mdK4NuOJ/+uuIxD//Be9a4lIbJnR7RQkdbZu
         aQARlloe4sbIv0WX5Qw0sdIUOvp7mYMF7fkK49LCxW/0Xbs9NaEbFuz1NsceCos/yEmC
         5sUQAG6pRmJ3vik+/gX6mQyECBzfc5FqVgR1ZAh/97pEfY1RKlVSo0KTxuMjRXiXYrRY
         YZMxfBycAalaXenJ0YsenBUaiHN8MqcjzJgrOpdRx2DC0RleJm3mpFoz30RBcmShGNF/
         7LOouncK3XsGdIUy0T9qQLdlCTC6dUOBGMq2q6tGKZxvGKNyYFHPqQnvMvCbBqo10+ny
         mJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683584667; x=1686176667;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GqRriGRUbsesORv9FIQ/f84+f/Gs1+ORAutqa65QH14=;
        b=bIAYwHORojWWxqePtuQmaXGkI9hwcjf/OIL1Z5YXv17dLAC0xGLSZ4qsWMXxh7oCo4
         GijHgmiGfub0YWchpmhJ+kVCL5KeufRc52Vdx/foZtaZhp0QB4Khn+3dbVFt7/oBEERu
         +zkU9kno+YgnQtuDdTkE7pwBnaMemIsN3mcSrIch9sJlrqPhI7ueQHCyfxZrJnJnKPiu
         yePu4L+Rsy9w1WeDn6UW5C2kbKZQTruSR2JRTCTewPA2OIcKh86/42RK3LwvXN4JCC7k
         Y0qzy9WoDgXZg2bRyeymYkmMtsCHPbXkZQ3Jk7XwPXyJlMaojuhiUmP1kRfYxfcOPCC0
         bEkA==
X-Gm-Message-State: AC+VfDzMjZrAVafWS8jsXxpH8GzCEe7xr4GDkCPn2vu9iaQASak7IC+x
	WEyplSa0A2k8D9RXZJy48g==
X-Google-Smtp-Source: ACHHUZ5npzY/0UAHqyGJlzv2f0Br7mJ1G14p+7z9e/woQK/Nkn7sMQk5hflbkNdfWRrzmwgxxgxcYw==
X-Received: by 2002:aca:220e:0:b0:384:3f55:ab96 with SMTP id b14-20020aca220e000000b003843f55ab96mr238988oic.25.1683584667276;
        Mon, 08 May 2023 15:24:27 -0700 (PDT)
Received: from C02FL77VMD6R ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id bm13-20020a0568081a8d00b0038bffe1332dsm472529oib.57.2023.05.08.15.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 15:24:26 -0700 (PDT)
Date: Mon, 8 May 2023 15:24:22 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net 5/6] net/sched: Refactor qdisc_graft() for ingress
 and clsact Qdiscs
Message-ID: <ZFl2ltqtVM5o8UpE@C02FL77VMD6R>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <1cd15c879d51e38f6b189d41553e67a8a1de0250.1683326865.git.peilin.ye@bytedance.com>
 <CAM0EoM=o862LdMEwmqpCSOFT=dMM8LhxgY3QUvpAow1rHSe7DA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoM=o862LdMEwmqpCSOFT=dMM8LhxgY3QUvpAow1rHSe7DA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 07:29:26AM -0400, Jamal Hadi Salim wrote:
> On Fri, May 5, 2023 at 8:15 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > Grafting ingress and clsact Qdiscs does not need a for-loop in
> > qdisc_graft().  Refactor it.  No functional changes intended.
> 
> This one i am not so sure;  num_q = 1 implies it will run on the for
> loop only once. I am not sure it improves readability either. Anyways
> for the effort you put into it i am tossing a coin and saying:
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Yeah, it doesn't make much difference itself.  I'm just afraid that,
without [5/6], [6/6] would look like:

		for (i = 0; i < num_q; i++) {
			if (!ingress) {
				dev_queue = netdev_get_tx_queue(dev, i);
				old = dev_graft_qdisc(dev_queue, new);
			else {
				old = dev_graft_qdisc(dev_queue, NULL);
			}

			if (new && i > 0)
				qdisc_refcount_inc(new);

			if (!ingress) {
				qdisc_put(old);
			} else {
                                /* {ingress,clsact}_destroy() "old" before grafting "new" to avoid
                                 * unprotected concurrent accesses to net_device::miniq_{in,e}gress
                                 * pointer(s) in mini_qdisc_pair_swap().
                                 */
				qdisc_notify(net, skb, n, classid, old, new, extack);
				qdisc_destroy(old);
			}

			if (ingress)
				dev_graft_qdisc(dev_queue, new);
		}

The "!ingress" path doesn't share a single line with "ingress", which
looks a bit weird to me.  Personally I'd like to keep [5/6].

Thanks,
Peilin Ye


