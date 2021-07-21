Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A83D097C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 09:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhGUGat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 02:30:49 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:57103 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233002AbhGUGag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 02:30:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UgV-rZj_1626851460;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UgV-rZj_1626851460)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Jul 2021 15:11:00 +0800
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1625657451.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <39d65414-d3af-5af5-e8e8-fc883731700e@linux.alibaba.com>
Date:   Wed, 21 Jul 2021 15:11:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <cover.1625657451.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/7/7 下午7:39, Pavel Begunkov 写道:
> Implement an old idea allowing open/accept io_uring requests to register
> a newly created file as a io_uring's fixed file instead of placing it
> into a task's file table. The switching is encoded in io_uring's SQEs
> by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
> think we need more, but may be a good idea to scrap u32 somewhere
> instead.
> 
>  From the net side only needs a function doing __sys_accept4_file()
> but not installing fd, see 2/4.
> 
> Only RFC for now, the new functionality is tested only for open yet.
> I hope we can remember the author of the idea to add attribution.
> 
Great feature! I believe this one leverages linked sqes, we may need to
remind users to be careful when they use this feature in shared sqthread
mode since linked sqes may be splited.
> Pavel Begunkov (4):
>    io_uring: allow open directly into fixed fd table
>    net: add an accept helper not installing fd
>    io_uring: hand code io_accept()' fd installing
>    io_uring: accept directly into fixed file table
> 
>   fs/io_uring.c                 | 113 +++++++++++++++++++++++++++++-----
>   include/linux/socket.h        |   3 +
>   include/uapi/linux/io_uring.h |   2 +
>   net/socket.c                  |  71 +++++++++++----------
>   4 files changed, 138 insertions(+), 51 deletions(-)
> 

