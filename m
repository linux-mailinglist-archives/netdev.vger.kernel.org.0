Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ECF1F01B4
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgFEV2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 17:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbgFEV2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 17:28:39 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49CBC08C5C2
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 14:28:38 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s1so11240957qkf.9
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 14:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EpPRgQ8lBIQjw6l7RmYyP3mNoKE7OxrnWWTzul6BSB4=;
        b=lWBLPcodg2gSLpqvvffyxc3HQXVMW9kekxRKC8X7sbDJ6D92UzFOCdPG3PIv7hsA4m
         yy3yzGoYlmT/syu1LOdB9ZmsL8+4fhCRVY0L1NOjjxOvleZ+Ew7mgOsFXeQs49Fz6U3z
         ZoBq0/wzVTuT7epiz18b/JJhdk794vhym6FvB0/hl+jOEzr04wa/dC/ptNIfeK9SGo+A
         fF81inMtA7XIjfPgX+FIJidUy/xjou66RkA+qValahq+WVPahjgze1oSES/vj62VIsuH
         +0akhjaKx5MYYJxoElmH2uQ1ZtZf2FB1ESyBbxmAdX9dYyqFNgH7wAGRjxLbXsKXD448
         pL0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EpPRgQ8lBIQjw6l7RmYyP3mNoKE7OxrnWWTzul6BSB4=;
        b=maAUKhtxNbogfK2wmrm86bJoNsakyH3EUGmUHQomdCIn3xXu0hO+RcLLEAeh4ucJ2M
         LD3zlb8P5kMHSdXYoihYsWVv8lXhT6DfrP01fcE1lYM6PP0y9BYMb7Axro3OSgAugVxj
         B80nZo5SNWPTwuKxpYkRYHbggi9t1l37ePJnwiq3+NDWgIzrsc+6HbyLWKDJelDYiePQ
         FwIUHrPCIjdI2wfB4FaQ4oqaNNY/Y1Wa8MVxaqVuh+npqATbz08r2O8vuMUMzOs98XRD
         vdIoinbupzdk7O6IpHtAoNGM6DgOJaUY4XF4u6iQHvcfcWQzUtxc7q+9+eeySlBrQoJo
         lYIw==
X-Gm-Message-State: AOAM530VbxiDAzPW454/yXZnhYmB5We+i5OynA5ualXj/TDyLxXWHu4Y
        NChtDVEJLCfya8vqDE52nHA=
X-Google-Smtp-Source: ABdhPJyLVS4SPG7de27Xf8vXxfVKX34lLtJXbldX6GUQ8/158n+w0zZ6IYxBh7liCEHyXjAMf0dR2g==
X-Received: by 2002:a37:607:: with SMTP id 7mr11390344qkg.385.1591392518130;
        Fri, 05 Jun 2020 14:28:38 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id p25sm883293qtj.18.2020.06.05.14.28.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2020 14:28:37 -0700 (PDT)
From:   Pooja Trivedi <poojatrivedi@gmail.com>
X-Google-Original-From: Pooja Trivedi <pooja.trivedi@stackpath.com>
To:     pooja.trivedi@stackpath.com, mallesh537@gmail.com,
        josh.tway@stackpath.com, viro@zeniv.linux.org.uk, ast@kernel.org,
        kafai@fb.com, daniel@iogearbox.net, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, netdev@vger.kernel.org
Cc:     Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
Subject: [RFC PATCH net] splice: Do not set SPLICE_F_MORE flag if end of file is reached
Date:   Fri,  5 Jun 2020 21:28:28 +0000
Message-Id: <1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SPLICE_F_MORE should only get set if read_len < len and pos does
not indicate file end. This is because the passed-in len can be
greater than file size and read_len < len could indicate that end
of file has been reached and there is no more pending data.

------

This issue was found during kTLS testing. Details as described in
https://lists.openwall.net/netdev/2020/06/02/146 are below:

When sendfile is used for kTLS file delivery and
the size provided to sendfile via its 'count'
parameter is greater than the file size, kTLS fails
to send the file correctly. The last chunk of the
file is not sent, and the data integrity of the
file is compromised on the receiver side.
Based on studying the sendfile source code, in
such a case, last chunk of the file will be passed
with the MSG_MORE flag set. Following snippet from
fs/splice.c:1814 shows code within the while loop
in splice_direct_to_actor() function that sets this
flag:

--------

	/*
	 * If more data is pending, set SPLICE_F_MORE
	 * If this is the last data and SPLICE_F_MORE
	 * was not set initially, clears it.
	 */
	if (read_len < len)
		sd->flags |= SPLICE_F_MORE;
	else if (!more)
		sd->flags &= ~SPLICE_F_MORE;

--------

Due to this, tls layer adds the chunk to the pending
records, but does not push it. Following lines of code
from tls_sw_do_sendpage() function in tls_sw.c:1153 show
the end of record (eor) variable being set based on
MSG_MORE flag:

--------

	bool eor;

	eor = !(flags & (MSG_MORE | MSG_SENDPAGE_NOTLAST));

--------

This eor bool is then used in the condition check for
full_record, end of record, or sk_msg_full in
tls_sw_do_sendpage() function in tls_sw.c:1212:

--------

	if (full_record || eor || sk_msg_full(msg_pl)) {
		ret = bpf_exec_tx_verdict(msg_pl, sk, full_record,
				  record_type, &copied, flags);
		if (ret) {
			if (ret == -EINPROGRESS)
				num_async++;
			else if (ret == -ENOMEM)
				goto wait_for_memory;
			else if (ret != -EAGAIN) {
				if (ret == -ENOSPC)
					ret = 0;
				goto sendpage_end;
			}
		}
	}
	continue;

--------

Changing the code in splice_direct_to_actor() function
in fs/splice.c to detect end of file by checking 'pos'
variable against file size, and setting MSG_MORE flag
only when EOF is not reached, fixes the issue:

In splice_direct_to_actor():988:

                 * If this is the last data and SPLICE_F_MORE was not set
                 * initially, clears it.
                 */
-               if (read_len < len)
-                       sd->flags |= SPLICE_F_MORE;
-               else if (!more)
+               if (read_len < len) {
+                       if (pos < i_size_read(file_inode(in)))
+                               sd->flags |= SPLICE_F_MORE;
+               } else if (!more)
                        sd->flags &= ~SPLICE_F_MORE;
+               }

-------

Here is the kTLS selftest that was submitted, and that helps
reproduce the issue: https://lists.openwall.net/netdev/2020/06/05/109

-------

Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
Signed-off-by: Mallesham Jatharkonda<mallesham.jatharkonda@oneconvergence.com>
Signed-off-by: Josh Tway <josh.tway@stackpath.com>
---
 fs/splice.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6b3c9a0..6408393 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -959,10 +959,12 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		 * If this is the last data and SPLICE_F_MORE was not set
 		 * initially, clears it.
 		 */
-		if (read_len < len)
-			sd->flags |= SPLICE_F_MORE;
-		else if (!more)
+		if (read_len < len) {
+			if (pos < i_size_read(file_inode(in)))
+				sd->flags |= SPLICE_F_MORE;
+		} else if (!more) {
 			sd->flags &= ~SPLICE_F_MORE;
+		}
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we
-- 
1.8.3.1

