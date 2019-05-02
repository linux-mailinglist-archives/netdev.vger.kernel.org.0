Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5410D11998
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfEBM6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfEBM6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 08:58:34 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8840F20449;
        Thu,  2 May 2019 12:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556801913;
        bh=X33l/3QpAup0yjpwAv67wcUoPXElvCJQqT97HlqjYiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OZExUn3962dW9lHir6D89D2tZtdnvp1YzlnoIapmcHVMKHqn2iY5QkDOq3v7MvRII
         3H+kP8ZwthAFa3xkLK6Vde5FL2jogEXSJok57y9o76UeOHLZGLfAxS0FBba9I9s3Tb
         hGl40L/e45SH6bOK4jzrtBRvzNnA0X1LZvmDeWac=
Date:   Thu, 2 May 2019 08:51:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.0 61/98] libceph: fix breakage caused by
 multipage bvecs
Message-ID: <20190502125145.GC11584@sasha-vm>
References: <20190422194205.10404-1-sashal@kernel.org>
 <20190422194205.10404-61-sashal@kernel.org>
 <CAOi1vP8Q=bH9uXVi=35PKpE0T=MNpRViaBJWPMYfD6_pfC8xRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP8Q=bH9uXVi=35PKpE0T=MNpRViaBJWPMYfD6_pfC8xRw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 23, 2019 at 10:28:56AM +0200, Ilya Dryomov wrote:
>On Mon, Apr 22, 2019 at 9:44 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ilya Dryomov <idryomov@gmail.com>
>>
>> [ Upstream commit 187df76325af5d9e12ae9daec1510307797e54f0 ]
>>
>> A bvec can now consist of multiple physically contiguous pages.
>> This means that bvec_iter_advance() can move to a different page while
>> staying in the same bvec (i.e. ->bi_bvec_done != 0).
>>
>> The messenger works in terms of segments which can now be defined as
>> the smaller of a bvec and a page.  The "more bytes to process in this
>> segment" condition holds only if bvec_iter_advance() leaves us in the
>> same bvec _and_ in the same page.  On next bvec (possibly in the same
>> page) and on next page (possibly in the same bvec) we may need to set
>> ->last_piece.
>>
>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
>> ---
>>  net/ceph/messenger.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index 7e71b0df1fbc..3083988ce729 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -840,6 +840,7 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
>>                                         size_t bytes)
>>  {
>>         struct ceph_bio_iter *it = &cursor->bio_iter;
>> +       struct page *page = bio_iter_page(it->bio, it->iter);
>>
>>         BUG_ON(bytes > cursor->resid);
>>         BUG_ON(bytes > bio_iter_len(it->bio, it->iter));
>> @@ -851,7 +852,8 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
>>                 return false;   /* no more data */
>>         }
>>
>> -       if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done))
>> +       if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done &&
>> +                      page == bio_iter_page(it->bio, it->iter)))
>>                 return false;   /* more bytes to process in this segment */
>>
>>         if (!it->iter.bi_size) {
>> @@ -899,6 +901,7 @@ static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
>>                                         size_t bytes)
>>  {
>>         struct bio_vec *bvecs = cursor->data->bvec_pos.bvecs;
>> +       struct page *page = bvec_iter_page(bvecs, cursor->bvec_iter);
>>
>>         BUG_ON(bytes > cursor->resid);
>>         BUG_ON(bytes > bvec_iter_len(bvecs, cursor->bvec_iter));
>> @@ -910,7 +913,8 @@ static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
>>                 return false;   /* no more data */
>>         }
>>
>> -       if (!bytes || cursor->bvec_iter.bi_bvec_done)
>> +       if (!bytes || (cursor->bvec_iter.bi_bvec_done &&
>> +                      page == bvec_iter_page(bvecs, cursor->bvec_iter)))
>>                 return false;   /* more bytes to process in this segment */
>>
>>         BUG_ON(cursor->last_piece);
>
>Same here, shouldn't be needed.

Dropped, thanks!

--
Thanks,
Sasha
