Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B782BAC4F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgKTO76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 09:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgKTO76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 09:59:58 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2431C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 06:59:56 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id d17so10202237ion.4
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 06:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0ev+vtzonlnX+q8/r8hhN7SdhSoYclUfgw0xLdzqzs8=;
        b=DyvMpBgH3jcTe4tGD66Q3hHRaB/9PvKjr7CjCyElclC8cfQ/24WT3lF7GJkWHo8ldd
         Fw17w1SYGVJYURCh9zcBzBoOENVxinSnzx9Jlk4tmYJu0eBPj10jhxjJVsysyJ9KbY41
         frxiE/kHDuMuyndXhAgEv7bTBfkp+E/JkoT6oC4z4ASfUV9Ugg1dTv31kmjMHhXPtKwD
         7gI/0ioh5dxXxPvRzBSNawI/IoVZDGlcS421BC3SHr7GDvvGtHNQejJNcbq+BXNxZ7it
         QhR7Bl4AlLZ0LSk08z91TxscJ1CfL9cOxAl5qdgGBUG2DkyLOyvQv6lXiRlF94XYmuCQ
         7mKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0ev+vtzonlnX+q8/r8hhN7SdhSoYclUfgw0xLdzqzs8=;
        b=SK+wO9UCD0HzqLl5XpgUCE69qBXlkXnO+4Da9NTo5YrdkTZ/BTgv/evUBcTdC5SQBF
         Eshm+ryt/1uIOPbY+lObgLh+5b4NwExh9+sAmjHk/vKP7dOpYJD5OG45RmzIi2wkvDjF
         +oH12Y7LSYko5R3eUNrNY3vq+e/X2Lt9Wpa0ujp+nD7pEbTaJK2tek6yOWNE9A9xOuzv
         Kjg1gClFvYLxOaZ4kEsedWRMzQydvLP1a0ztRL6IF1J6eDvlNurD39vUNeVWTiRKrjmt
         tmyNmcE6TcxzpBbHpgs/+b3nzSrE81n6SOCC749fMH4/UZ+zHNZde27di/v67ZEdCiSi
         vNsw==
X-Gm-Message-State: AOAM533Q49moKs4zQznDsxqqVqB6LR0F0zRVm4mO+r4frWMO16fpMIlm
        646PHu7qZaxjEx4k/vHZ03eVVQ==
X-Google-Smtp-Source: ABdhPJykr1/4vLJ05hWZfkzkyBgwb/gRY/c5eScaT6WtAsTrd7KTHhfuM90BOFUo6dbTiJlw7HosnQ==
X-Received: by 2002:a5e:c912:: with SMTP id z18mr7119836iol.185.1605884395997;
        Fri, 20 Nov 2020 06:59:55 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 10sm2046499ill.75.2020.11.20.06.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 06:59:54 -0800 (PST)
To:     Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] tun: honor IOCB_NOWAIT flag
Message-ID: <e9451860-96cc-c7c7-47b8-fe42cadd5f4c@kernel.dk>
Date:   Fri, 20 Nov 2020 07:59:54 -0700
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

