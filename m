Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A26533A381
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 09:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhCNIXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 04:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhCNIXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 04:23:13 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677D1C061574;
        Sun, 14 Mar 2021 00:23:13 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id c10so61085828ejx.9;
        Sun, 14 Mar 2021 00:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=HEGwvNj8hmctDu6Y38pjXgmnmgSAbCOwl+eKGB6BT7Q=;
        b=RdLk0ZGQksxI2qNvYW7NMxAFT6zQ527v6R5E47ewr9400SYRWWlG3YZATM8d2ftmBG
         BGt7ax+FT2fm5djbbtMQ2Bd+LwKWNSWHHDwpfwZ5tYnA5InDFT+AzeS+dsPyjEHllYGh
         nABziG+E2ALGjH00WUh3izIyJDcQ9sDS4i55tbU9yULVKiXHmBXZl+cSsVeoQQst5MzS
         0MN//bfodurvqR9CaSAJz3iMtx/IK7fh2OGzpLnZCPtj0IgeqKilV3NrhpTxqwictoWu
         F2Nk9A6hBPGxIOIgh2soY8j/fYPS9pOs0IxJj+sb14bJOyGWU+D+XsJpoLDBykjr681e
         /7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=HEGwvNj8hmctDu6Y38pjXgmnmgSAbCOwl+eKGB6BT7Q=;
        b=O8Yj4jlUSd6f4QY154xcgEiurCQAYWWb5SpOhbv7iYH+Yt0/WuEJg0D0j0SpzyM94d
         u+cdtSm3PR5dBfCvgIC9BPmqcgA8j+3mayHceHuPq4TdCcBXkIOaRYicZHyBGCYbgDR2
         PGJRrSJ/yyb05ptQN7sTCog51vAOakP+xDC0HIi4LFEChkiW92NrPu2AdVijSMdypJq1
         y0E4E+XqbZtMOrukjSIvdB40LBNH4RPnvZdAXN1bEBz5GuwCYYjUqkpzZQo1P6UmBjAJ
         xPqi+7qm/09CCEVX/TEHZAdm6seS9mPb+1P3QScI0Ew2ijizbkztpcspBDoh0dlJFv+G
         W0Fg==
X-Gm-Message-State: AOAM533s91ayg/dbKbherbQdiYOihw2N4kZ7T1umy0S1BFDxbDkuhHdt
        iP8F+XwMyoBz+I1ImgcsQHk=
X-Google-Smtp-Source: ABdhPJw+5BFp7onDqRrzndi0rN0+ztojC7b/WXytbaVDBwPlBjYtONmumZdf6kXT8dYNs+tRCyUhIQ==
X-Received: by 2002:a17:906:1c13:: with SMTP id k19mr17848112ejg.457.1615710192163;
        Sun, 14 Mar 2021 00:23:12 -0800 (PST)
Received: from TRWS9215 ([88.245.22.54])
        by smtp.gmail.com with ESMTPSA id gz20sm5516205ejc.25.2021.03.14.00.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 00:23:11 -0800 (PST)
Message-ID: <a3036ea4ee2a06e4b3acd3b438025754d11f65fc.camel@gmail.com>
Subject: [BUG] net: rds: rds_send_probe memory leak
From:   Fatih Yildirim <yildirim.fatih@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Date:   Sun, 14 Mar 2021 11:23:10 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

I've been working on a memory leak bug reported by syzbot.
https://syzkaller.appspot.com/bug?id=39b72114839a6dbd66c1d2104522698a813f9ae2

It seems that memory allocated in rds_send_probe function is not freed.

Let me share my observations.
rds_message is allocated at the beginning of rds_send_probe function.
Then it is added to cp_send_queue list of rds_conn_path and refcount
is increased by one.
Next, in rds_send_xmit function it is moved from cp_send_queue list to
cp_retrans list, and again refcount is increased by one.
Finally in rds_loop_xmit function refcount is increased by one.
So, total refcount is 4.
However, rds_message_put is called three times, in rds_send_probe,
rds_send_remove_from_sock and rds_send_xmit functions. It seems that
one more rds_message_put is needed.
Would you please check and share your comments on this issue?

Thanks,
Fatih


