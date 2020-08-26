Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162F0252AA8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgHZJs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:48:27 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:22715 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgHZJsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598435305; x=1629971305;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=diY33+Y0wSrpORwcKwKC5QHO34O4GPmLugcBqTgpFsQ=;
  b=YGRHeY06RM4tOMvMF90wiWJRTGI7/tCNoew6C9PT4KeRllL9aoj0EA0Z
   qVzdk5Z1vfE0+DiAfZDKKKf21a3GRN5tS7k2FTLKfGO0LZtQLiX4avnGy
   mutqCk9vQuV/FdhrHI+FfxHun4GhSQAcVMJ/BXv84YNlyrEmNHhCmg8pt
   w=;
X-IronPort-AV: E=Sophos;i="5.76,355,1592870400"; 
   d="scan'208";a="62849569"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 Aug 2020 09:48:10 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id D39DBA0678;
        Wed, 26 Aug 2020 09:48:08 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.85) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 09:48:03 +0000
References: <cover.1597842004.git.lorenzo@kernel.org> <c2665f369ede07328bbf7456def2e2025b9b320e.1597842004.git.lorenzo@kernel.org> <pj41zlft8dsbdt.fsf@u68c7b5b1d2d758.ant.amazon.com> <20200824104442.023bdd11@carbon>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <lorenzo.bianconi@redhat.com>, <echaudro@redhat.com>,
        <sameehj@amazon.com>, <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/6] xdp: introduce mb in xdp_buff/xdp_frame
In-Reply-To: <20200824104442.023bdd11@carbon>
Date:   Wed, 26 Aug 2020 12:47:42 +0300
Message-ID: <pj41zlv9h5pwld.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D30UWB003.ant.amazon.com (10.43.161.83) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Sun, 23 Aug 2020 17:08:30 +0300
> Shay Agroskin <shayagr@amazon.com> wrote:
>
>> > diff --git a/include/net/xdp.h b/include/net/xdp.h
>> > index 3814fb631d52..42f439f9fcda 100644
>> > --- a/include/net/xdp.h
>> > +++ b/include/net/xdp.h
>> > @@ -72,7 +72,8 @@ struct xdp_buff {
>> >  	void *data_hard_start;
>> >  	struct xdp_rxq_info *rxq;
>> >  	struct xdp_txq_info *txq;
>> > -	u32 frame_sz; /* frame size to deduce 
>> > data_hard_end/reserved tailroom*/
>> > +	u32 frame_sz:31; /* frame size to deduce 
>> > data_hard_end/reserved tailroom*/
>> > +	u32 mb:1; /* xdp non-linear buffer */
>> >  };
>> >  
>> >  /* Reserve memory area at end-of data area.
>> > @@ -96,7 +97,8 @@ struct xdp_frame {
>> >  	u16 len;
>> >  	u16 headroom;
>> >  	u32 metasize:8;
>> > -	u32 frame_sz:24;
>> > +	u32 frame_sz:23;
>> > +	u32 mb:1; /* xdp non-linear frame */  
>> 
>> Although this issue wasn't introduced with this patch, why not 
>> make frame_sz field to be the same size in xdp_buff and 
>> xdp_frame 
>> ?
>
> This is all about struct layout and saving memory size, due to
> cacheline access. Please read up on this and use the tool pahole 
> to
> inspect the struct memory layout.

I actually meant reducing the size of frame_sz in xdp_buff 
(without changing xdp_frame so that it still fits 64 byte cache 
line). Reducing a field size shouldn't affect cache alignment as 
far as I can see.
Doesn't matter all that much to me, I simply find it a better 
practice that the same field would have same size in different 
structs.

Shay
