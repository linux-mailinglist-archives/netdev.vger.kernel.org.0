Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642B3117EB7
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfLJEGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:06:34 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41253 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLJEGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:06:34 -0500
Received: by mail-pf1-f196.google.com with SMTP id s18so8347330pfd.8
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 20:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=q94VQzty0jDRHfngmIe2AOVqU1yspLHXgaDr4wODD1E=;
        b=TTPXPomnOIGpcT03S8tmQpQdDQTwbbXNqqX/8TNduD0xrbqxafNseEKJlj75MRMZwJ
         ftFgCsb2utlFg+/cMjH3uoU1yLYwcw+rp2hy2VJqm6O1sP7V42G6jHJpQ8wjPBqXPq8+
         lx5otb1ruYjmNZUht36ZeA9Mhr1L+1B/gnVN2FU54W/du2jfcP3SfofE8qV/GzXQf6yw
         8kjCHdq0ufvEOaqV3jvVSWxaZ3zx6tS87wR3N6LyYy6j5TUxOzWUxhJm9JZdunE6j0wx
         onLMNDEPyNuv/DQ9HEH589c9t0iUHcLXou+aHRouVHb37zhgBC6s/Ukc9NgS/kEK4+IK
         nneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=q94VQzty0jDRHfngmIe2AOVqU1yspLHXgaDr4wODD1E=;
        b=Gt0A+8BGIUe1O2L/LvezfXFDH4YBYwNLDuKPIvh9o61nhiu0CLxcWx85TXpqjSDFtn
         48zcNegj/DRI2ZPx1Iuf6iAX8B4dT/QUb1wvYfdGuWgv/rL4f+GogphAci5tJrFNxMj1
         TM1zzjJuUA+NphQVTjrXsUj2Htd0fFnE2VXJvtOg8RN9i/QnLoMe1WGWC5CTdJ4x+q8J
         D3GcTX6OaMq0lZoU8PW50cU/E5I6Kox/8in/xbeSHNYvlEGb4gm0MP/+PLXp5oaw9TVd
         //AnGHu3g0rzTR+mpK4SFREOsybgKO6ypAdYkUqD9nAaOPd9soF8YFiRWAnwkDmJf+1o
         z8+w==
X-Gm-Message-State: APjAAAWCkQYJl7bqEObeHWPJ5mLsIzu7+wt7BpGFjYM8BX+cGax8qrA5
        NPyrAcO9Wf0h+nmNTBcur+A9wV7XX7M=
X-Google-Smtp-Source: APXvYqynekSuRyd7WHeD/nvWISdM3XrIpUIKAaS7LfLF7LkzDuXUqZdy8OsgxQd76sXWjuQkt+I5rg==
X-Received: by 2002:a62:7c54:: with SMTP id x81mr14176037pfc.180.1575950793530;
        Mon, 09 Dec 2019 20:06:33 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c7? ([2620:10d:c090:180::240])
        by smtp.gmail.com with ESMTPSA id z23sm1031975pgj.43.2019.12.09.20.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 20:06:32 -0800 (PST)
To:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] net: make socket read/write_iter() honor IOCB_NOWAIT
Message-ID: <c2567518-9bde-0491-b8fd-c4afee8ff27c@kernel.dk>
Date:   Mon, 9 Dec 2019 21:06:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The socket read/write helpers only look at the file O_NONBLOCK. not
the iocb IOCB_NOWAIT flag. This breaks users like preadv2/pwritev2
and io_uring that rely on not having the file itself marked nonblocking,
but rather the iocb itself.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This seems like a gross oversight? Verified that it's broken, and
verified that it works for me with this check added.

diff --git a/net/socket.c b/net/socket.c
index b343db1489bd..b116e58d6438 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -957,7 +957,7 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			     .msg_iocb = iocb};
 	ssize_t res;
 
-	if (file->f_flags & O_NONBLOCK)
+	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
 		msg.msg_flags = MSG_DONTWAIT;
 
 	if (iocb->ki_pos != 0)
@@ -982,7 +982,7 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos != 0)
 		return -ESPIPE;
 
-	if (file->f_flags & O_NONBLOCK)
+	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
 		msg.msg_flags = MSG_DONTWAIT;
 
 	if (sock->type == SOCK_SEQPACKET)

-- 
Jens Axboe

