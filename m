Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E771108F8E
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 15:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfKYOGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 09:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbfKYOGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 09:06:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7082520748;
        Mon, 25 Nov 2019 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574690812;
        bh=BzJVgwBAwb4fHGnSImlrlJjuXvyWjGJYoST3KN7QX9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z862imtl/relCWKoHlsc4QFiNhnxcLP5NhqfeYNWAUk8xjWW30M1VqkJ6VYJMXrSB
         HjkopeqGLOz0pa6coQJcGrf68iQmAOmX68RIQIcs3jLNUzSi0N13e8nb0ealzXLFw1
         2LbhyFX5pkc3JSly90U3IdUEq8hWGnosckklFZD4=
Date:   Mon, 25 Nov 2019 09:06:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 100/237] libceph: don't consume a ref on
 pagelist in ceph_msg_data_add_pagelist()
Message-ID: <20191125140651.GE5861@sasha-vm>
References: <20191116154113.7417-1-sashal@kernel.org>
 <20191116154113.7417-100-sashal@kernel.org>
 <CAOi1vP8ZTyaGsn-hXtnr+AnCrEQfSB6sTLYwkkZ8P1oY9EgPXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP8ZTyaGsn-hXtnr+AnCrEQfSB6sTLYwkkZ8P1oY9EgPXg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 05:23:28PM +0100, Ilya Dryomov wrote:
>On Sat, Nov 16, 2019 at 4:43 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ilya Dryomov <idryomov@gmail.com>
>>
>> [ Upstream commit 894868330a1e038ea4a65dbb81741eef70ad71b1 ]
>>
>> Because send_mds_reconnect() wants to send a message with a pagelist
>> and pass the ownership to the messenger, ceph_msg_data_add_pagelist()
>> consumes a ref which is then put in ceph_msg_data_destroy().  This
>> makes managing pagelists in the OSD client (where they are wrapped in
>> ceph_osd_data) unnecessarily hard because the handoff only happens in
>> ceph_osdc_start_request() instead of when the pagelist is passed to
>> ceph_osd_data_pagelist_init().  I counted several memory leaks on
>> various error paths.
>>
>> Fix up ceph_msg_data_add_pagelist() and carry a pagelist ref in
>> ceph_osd_data.
>>
>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  fs/ceph/mds_client.c  | 2 +-
>>  net/ceph/messenger.c  | 1 +
>>  net/ceph/osd_client.c | 8 ++++++++
>>  3 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 09db6d08614d2..94494d05a94cb 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2184,7 +2184,6 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>>
>>         if (req->r_pagelist) {
>>                 struct ceph_pagelist *pagelist = req->r_pagelist;
>> -               refcount_inc(&pagelist->refcnt);
>>                 ceph_msg_data_add_pagelist(msg, pagelist);
>>                 msg->hdr.data_len = cpu_to_le32(pagelist->length);
>>         } else {
>> @@ -3289,6 +3288,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
>>         mutex_unlock(&mdsc->mutex);
>>
>>         up_read(&mdsc->snap_rwsem);
>> +       ceph_pagelist_release(pagelist);
>>         return;
>>
>>  fail:
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index f7d7f32ac673c..2c8cd339d59ea 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -3323,6 +3323,7 @@ void ceph_msg_data_add_pagelist(struct ceph_msg *msg,
>>
>>         data = ceph_msg_data_create(CEPH_MSG_DATA_PAGELIST);
>>         BUG_ON(!data);
>> +       refcount_inc(&pagelist->refcnt);
>>         data->pagelist = pagelist;
>>
>>         list_add_tail(&data->links, &msg->data);
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 76c41a84550e7..c3494c1fb3a9a 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -126,6 +126,9 @@ static void ceph_osd_data_init(struct ceph_osd_data *osd_data)
>>         osd_data->type = CEPH_OSD_DATA_TYPE_NONE;
>>  }
>>
>> +/*
>> + * Consumes @pages if @own_pages is true.
>> + */
>>  static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
>>                         struct page **pages, u64 length, u32 alignment,
>>                         bool pages_from_pool, bool own_pages)
>> @@ -138,6 +141,9 @@ static void ceph_osd_data_pages_init(struct ceph_osd_data *osd_data,
>>         osd_data->own_pages = own_pages;
>>  }
>>
>> +/*
>> + * Consumes a ref on @pagelist.
>> + */
>>  static void ceph_osd_data_pagelist_init(struct ceph_osd_data *osd_data,
>>                         struct ceph_pagelist *pagelist)
>>  {
>> @@ -362,6 +368,8 @@ static void ceph_osd_data_release(struct ceph_osd_data *osd_data)
>>                 num_pages = calc_pages_for((u64)osd_data->alignment,
>>                                                 (u64)osd_data->length);
>>                 ceph_release_page_vector(osd_data->pages, num_pages);
>> +       } else if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGELIST) {
>> +               ceph_pagelist_release(osd_data->pagelist);
>>         }
>>         ceph_osd_data_init(osd_data);
>>  }
>
>Hi Sasha,
>
>This commit was part of a larger series and shouldn't be backported on
>its own.  Please drop it.

Dropped, thanks!

-- 
Thanks,
Sasha
