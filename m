Return-Path: <netdev+bounces-10157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6827772C952
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A69DC1C20846
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8802C1C755;
	Mon, 12 Jun 2023 15:06:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E119BA9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:06:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489B3186
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686582392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B9B4WSsY1Q3qtDpHU5mrDvfpvSIqwE8BQFlgw1iUIkU=;
	b=i4Se9o9iYsFV6gu0O10sz5NHrIXCQa32IRqQFqyUHbB5qIVJanb8DjgdnkYBa0KAmAAHHH
	ENC5hVc8YhUvgMv7MKYRyYsl3kCaFk/TPJBEfgxEUl/s06NWxiPAtPlCPM12yuTkdGH3w6
	goPhBBXoJa15B2f7iELVmsq+MrqMSOo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-LXo5EK5MPpepzlxk56eKQg-1; Mon, 12 Jun 2023 11:06:23 -0400
X-MC-Unique: LXo5EK5MPpepzlxk56eKQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62F11C068F4;
	Mon, 12 Jun 2023 15:06:22 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.17.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15413200A398;
	Mon, 12 Jun 2023 15:06:22 +0000 (UTC)
From: Aaron Conole <aconole@redhat.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Eelco Chaudron <echaudro@redhat.com>,  wangchuanlei
 <wangchuanlei@inspur.com>,  dev@openvswitch.org,  netdev@vger.kernel.org,
  wangpeihui@inspur.com,  kuba@kernel.org,  pabeni@redhat.com,
  davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net v2] net: openvswitch: fix upcall counter
 access before allocation
References: <20230607010529.1085986-1-wangchuanlei@inspur.com>
	<0E3E5A3D-E1C5-4C27-BEEB-432891F996F4@redhat.com>
	<ZIGWcLy8ivB6IeGK@corigine.com>
Date: Mon, 12 Jun 2023 11:06:21 -0400
In-Reply-To: <ZIGWcLy8ivB6IeGK@corigine.com> (Simon Horman's message of "Thu,
	8 Jun 2023 10:50:56 +0200")
Message-ID: <f7tfs6w3eky.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Simon Horman <simon.horman@corigine.com> writes:

> On Wed, Jun 07, 2023 at 11:09:58AM +0200, Eelco Chaudron wrote:
>
> ...
>
>> >> We moved the per cpu upcall counter allocation to the existing vport
>> >> alloc and free functions to solve this.
>> >>
>> >> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on
>> >> failure")
>> >> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall
>> >> packets")
>> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> >> ---
>> >
>> > Acked-by: Aaron Conole <aconole@redhat.com>
>>=20
>> Were you intentionally ACKing this on Aaron=E2=80=99s behalf? Or just a =
cut/paste error ;)
>
> I was wondering that too.
> But then I concluded it was an artifact of top-posting or some
> other behaviour of the mail client.

Thankfully, I did ack the patch, but yes, this is something to be
careful.

To wangchuanlei <wangchuanlei@inspur.com>, please read

  https://people.kernel.org/tglx/

Specifically, do not top-post for this and other reasons.


