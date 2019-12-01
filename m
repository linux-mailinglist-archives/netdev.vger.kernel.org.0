Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927C910E236
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 15:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfLAOek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 09:34:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfLAOej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 09:34:39 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098B120725;
        Sun,  1 Dec 2019 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575210878;
        bh=K8rs8jjTNo+YjtPHch9ujxhFdvlkbw04xZ/DlEjvXmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8LvnoV+ZPy/EFvVU0aJRwEOLjieEn833fKjD4mA1VvGWFWPgDzkbvmwPpedC01uS
         4v5RBKw7xncGiVV7KGxzU4J231F8BfqeXGG69xfzgH/8kE1chbYSSl6hE7tPMqVnJT
         Ke3CEUQp3PVqEw+u6cztQz1F1v+MEx6/EQdhXnhw=
Date:   Sun, 1 Dec 2019 09:34:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 140/219] libceph: drop last_piece logic from
 write_partial_message_data()
Message-ID: <20191201143436.GS5861@sasha-vm>
References: <20191122054911.1750-1-sashal@kernel.org>
 <20191122054911.1750-133-sashal@kernel.org>
 <CAOi1vP9MCrPf44V2GMyODH185A0HJcuPsYfVkOAVGkcMRb+=iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP9MCrPf44V2GMyODH185A0HJcuPsYfVkOAVGkcMRb+=iw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 03:00:43PM +0100, Ilya Dryomov wrote:
>On Fri, Nov 22, 2019 at 6:51 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ilya Dryomov <idryomov@gmail.com>
>>
>> [ Upstream commit 1f6b821aef78e3d79e8d598ae59fc7e23fb6c563 ]
>>
>> last_piece is for the last piece in the current data item, not in the
>> entire data payload of the message.  This is harmful for messages with
>> multiple data items.  On top of that, we don't need to signal the end
>> of a data payload either because it is always followed by a footer.
>>
>> We used to signal "more" unconditionally, until commit fe38a2b67bc6
>> ("libceph: start defining message data cursor").  Part of a large
>> series, it introduced cursor->last_piece and also mistakenly inverted
>> the hint by passing last_piece for "more".  This was corrected with
>> commit c2cfa1940097 ("libceph: Fix ceph_tcp_sendpage()'s more boolean
>> usage").
>>
>> As it is, last_piece is not helping at all: because Nagle algorithm is
>> disabled, for a simple message with two 512-byte data items we end up
>> emitting three packets: front + first data item, second data item and
>> footer.  Go back to the original pre-fe38a2b67bc6 behavior -- a single
>> packet in most cases.
>>
>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  net/ceph/messenger.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index f7d7f32ac673c..6514816947fbe 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -1612,7 +1612,6 @@ static int write_partial_message_data(struct ceph_connection *con)
>>                 struct page *page;
>>                 size_t page_offset;
>>                 size_t length;
>> -               bool last_piece;
>>                 int ret;
>>
>>                 if (!cursor->resid) {
>> @@ -1620,10 +1619,9 @@ static int write_partial_message_data(struct ceph_connection *con)
>>                         continue;
>>                 }
>>
>> -               page = ceph_msg_data_next(cursor, &page_offset, &length,
>> -                                         &last_piece);
>> -               ret = ceph_tcp_sendpage(con->sock, page, page_offset,
>> -                                       length, !last_piece);
>> +               page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
>> +               ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
>> +                                       true);
>>                 if (ret <= 0) {
>>                         if (do_datacrc)
>>                                 msg->footer.data_crc = cpu_to_le32(crc);
>
>Hi Sasha,
>
>This commit was part of a larger series and shouldn't be backported on
>its own.  Please drop it.

Now dropped, thanks!

-- 
Thanks,
Sasha
