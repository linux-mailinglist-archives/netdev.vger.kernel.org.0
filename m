Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7A2BAC4E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgKTO7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 09:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgKTO7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 09:59:47 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E107C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 06:59:47 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id l12so8811570ilo.1
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 06:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0ev+vtzonlnX+q8/r8hhN7SdhSoYclUfgw0xLdzqzs8=;
        b=s089ZVTln1bL2Ghw1mB32NFy7WofNDkegNU8GNk2a5CyErzy5WOCIp8xB89MKiFZsz
         u8HzqYjh4+FsusRJnaOUuRLfoRssYC9B0OadcxvLvKFVwM0ps1nJ1hDSX/mU4pPvYdFm
         hvtObHQaSpW4Jv16kHo7Gkef4BWQtk30+WTIe8GWJlswsO0GiNluz/cz8CkmEQmIf97E
         LMySDDwh3WgKa/HRAtALxQn0Hm2SZCBvTEAs5vBQtm4JwAp79FOPDl9tLyhiigLVlEc7
         GgoKj/Ig2/OjS0/EySnxftLtKXO7I0DOrI8O5BTNbNbqjT+ghW4AplkOdXP2Nl5HgIOJ
         7SiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0ev+vtzonlnX+q8/r8hhN7SdhSoYclUfgw0xLdzqzs8=;
        b=heNXJfba0b1uFLCf9IJM5/83uDKfc1FM5NxNnOxGUUA+MB4JkDhKJVdT0UuqLBvBpo
         EFeJom7T3sC+DWyMqYr5tPk20O3qYXzrB6YNdpBjPz3+b1L9QxTcWqL8KPCDGkS05Z5Q
         ta0wcgM8/89qe0Pt/UHm+I7cVEwG+JsP1GUUdz4GAiAAFUrn61XQcfKFbg3W/qxX3Kg8
         C3y0cd0DuP2VjaEWQz0WVMhoTPRAdLb/SRSLOLy5ZXXTOCAqH8B6qGBrx53AuPUOzuL6
         V0Pqxuw0F1dlWFHOYdib0vYP+5RhqjQ2kELbG91CeMGLqsnCE8EGQbVfcqtW3iNFi6Pe
         iPfw==
X-Gm-Message-State: AOAM532uJJ+7EgH0U7GB6HiNKauQv/9vT0020UZaq/mQI3VzN8t0LWZ0
        rs8RlCQSEnuRbf2xZAxxFIofk7EO5/+p3w==
X-Google-Smtp-Source: ABdhPJwGU2CBL0nh+81lm+/RM3SLhazj1i9uNIHL2mhV9IyyusQSTXfpsErU+4CfkkzIwF/dtfMJ6g==
X-Received: by 2002:a92:50e:: with SMTP id q14mr9433091ile.306.1605884386602;
        Fri, 20 Nov 2020 06:59:46 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x5sm2057933ilc.15.2020.11.20.06.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 06:59:45 -0800 (PST)
To:     Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] tun: honor IOCB_NOWAIT flag
Message-ID: <ac5dc509-fd62-7c77-4634-bdfb51858157@kernel.dk>
Date:   Fri, 20 Nov 2020 07:59:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tun only checks the file O_NONBLOCK flag, but it should also be checking
the iocb IOCB_NOWAIT flag. Any fops using ->read/write_iter() should check
both, otherwise it breaks users that correctly expect O_NONBLOCK semantics
if IOCB_NOWAIT is set.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Had a bug report on io_uring, and it's due to tun not honoring
IOCB_NOWAIT. Let's get this fixed.

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index be69d272052f..cd06cae76035 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1961,12 +1961,15 @@ static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = tun_get(tfile);
 	ssize_t result;
+	int noblock = 0;
 
 	if (!tun)
 		return -EBADFD;
 
-	result = tun_get_user(tun, tfile, NULL, from,
-			      file->f_flags & O_NONBLOCK, false);
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
+
+	result = tun_get_user(tun, tfile, NULL, from, noblock, false);
 
 	tun_put(tun);
 	return result;
@@ -2185,10 +2188,15 @@ static ssize_t tun_chr_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = tun_get(tfile);
 	ssize_t len = iov_iter_count(to), ret;
+	int noblock = 0;
 
 	if (!tun)
 		return -EBADFD;
-	ret = tun_do_read(tun, tfile, to, file->f_flags & O_NONBLOCK, NULL);
+
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
+
+	ret = tun_do_read(tun, tfile, to, noblock, NULL);
 	ret = min_t(ssize_t, ret, len);
 	if (ret > 0)
 		iocb->ki_pos = ret;

-- 
Jens Axboe

