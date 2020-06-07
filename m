Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945731F0FE3
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 22:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgFGUwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 16:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGUwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 16:52:34 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F09C08C5C3
        for <netdev@vger.kernel.org>; Sun,  7 Jun 2020 13:52:32 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id e12so11763695eds.2
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 13:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1G07w47LS2GVvWUAMlEyfb7I8BzMHJf84EiK66bALbQ=;
        b=J1MUpiUqYS+rrSFVW5LZGZpGL6fHw2RfH4phpJD/E4yehFBT7rmPgS5HkviEdJ0Sfk
         04Dk6/QX5sF26qs0zckwfK41r6sG8y707X1erkXzD8g5Hq8C78yw4zNZLSMqH9BwtBu0
         ZvjmWzRChrNW53ZOrUzD36PI7OAlA3uHHZ8kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1G07w47LS2GVvWUAMlEyfb7I8BzMHJf84EiK66bALbQ=;
        b=DMKBj4poyaNE69uL5C9CVh46ArRjHAvU9QUM68RjfmqaRX85MVKexXmJnBIbICF0dt
         u1C6qbOCYc5vModWoMP5H+XE3LZn/Ranjz8+9FG54tFVnQRv1Vy0KlZVxYFuryq9NsFC
         1OvUJf87NQZvldPgIiBETby8zrIa+/ZNk4Razd5vHZTgiZM6bpuX6jLQVrEhs0ZMfalB
         eyl/4HnTFoTVrZiW0aFt4iwNJZ/kwjvNev1jN6h9LLMHAhgTGNnpkZ/6MY5y7Q0GN5ak
         j3MbPxXyNHwpuX80Aexl7l+3RkD7oJNBNUxPirXnp+sOZQGkNBjVA+5ElzyDK6m1JzZ6
         UefA==
X-Gm-Message-State: AOAM532xzb2sOPgc58yvmkY28FmEKL7ypqQR3UQw+i+s9cJxtbCk5p12
        BoPbiTohzxgKLWx9Q+5yUHZURQ==
X-Google-Smtp-Source: ABdhPJzxDb97vWcWqEd/4PXkAxGxWDt+GyQa76dMfiGJr/gV3QPTaG4SvzNBoSOXmXokgw+S5sEEZQ==
X-Received: by 2002:aa7:da46:: with SMTP id w6mr18926329eds.31.1591563151012;
        Sun, 07 Jun 2020 13:52:31 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h8sm10887095edk.72.2020.06.07.13.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 13:52:30 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf 0/2] Fixes for sock_hash_free
Date:   Sun,  7 Jun 2020 22:52:27 +0200
Message-Id: <20200607205229.2389672-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is an attempt to fix a race in sock_hash_free recently reported
by Eric [0]. The race, and a mem leak I found on the way, can be triggered
by the crude reproducer posted below.

[0] https://lore.kernel.org/bpf/6f8bb6d8-bb70-4533-f15b-310db595d334@gmail.com/

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>

--8<--

enum { NUM_SOCKS = 1000 };

static void *close_map(void *map)
{
	close(*(int *)map);
	return NULL;
}

int main(void)
{
	int sock[NUM_SOCKS];
	pthread_t worker;
	int map;
	int i, err;

	map = bpf_create_map(BPF_MAP_TYPE_SOCKHASH, sizeof(int), sizeof(int), NUM_SOCKS, 0);
	if (map < 0)
		error(1, -map, "map create");

	for (i = 0; i < NUM_SOCKS; i++) {
		int fd = socket(AF_INET, SOCK_STREAM, 0);
		if (fd < 0)
			error(1, errno, "socket");

		err = listen(fd, SOMAXCONN);
		if (err)
			error(1, errno, "listen");

		sock[i] = fd;
		err = bpf_map_update_elem(map, &i, &fd, BPF_ANY);
		if (err)
			error(1, errno, "map update");
	}

	err = pthread_create(&worker, NULL, close_map, &map);
	if (err)
		error(1, err, "thread create");

	/* usleep(100); */

	for (int i = 0; i < NUM_SOCKS; i++)
		close(sock[i]);

	pthread_join(worker, NULL);
	return 0;
}
-->8--

Jakub Sitnicki (2):
  bpf, sockhash: Fix memory leak when unlinking sockets in
    sock_hash_free
  bpf, sockhash: Synchronize delete from bucket list on map free

 net/core/sock_map.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

-- 
2.25.4

