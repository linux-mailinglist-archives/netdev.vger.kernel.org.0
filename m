Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F18FFEA30
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 02:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfKPBz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 20:55:59 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:49446 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfKPBz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 20:55:59 -0500
Received: by mail-pg1-f201.google.com with SMTP id x15so2050352pgk.16
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 17:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a7+pWNks8C/y7Sgvv9NuMtlH/3FNssgIQbnc0bxUQ5w=;
        b=JRKgN1bo1x5K5UozlYxOaSE3ty3IJr3B4CE3hxGzDSRkjYBA9EYhFfE5kmPtjmlIPV
         5mQeAuJOF21/kWuqhpEcMwp22SOo999mK5wWs9W5iKstSMzB9H7u3Mz3jAiq7EtX21Dl
         dLxctT8vaJhhK4B+W7m5lD+Jq3//OD5LJSB/HaTRXSwXGtQRWh5G+f/uMeKL2BprE0OJ
         7y+EHYxA5y2SZUmP4Un/BGu5ndGsNCgzNHTYxWEPg6NS42oZe6Cap4/EBSZ0XMxXdQEX
         j+rllIZiylhlev7rmUuWI+nZl2ObUS9rrTeP3xnvVAoBIx+du2ZMIf30UhTcbpP0IHST
         iVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=a7+pWNks8C/y7Sgvv9NuMtlH/3FNssgIQbnc0bxUQ5w=;
        b=DaXHVcpbp6m9UXjNcnH2VVqSUAsUGb3miYauphwOzwtzzY4/BKXz3X4oAGAhUWBR7L
         lf7Im7JxIO2JrGoqwXl9N3476jfJ4kTT6vud5LaLA6X+p1XqdXK1xGAVIn0NNfTxNZFX
         GTsmjleboq9e9A/KwFresqCL2WyJlpOb/DPRp0uM4zUDp1VZpTu+EyQZ4uCQ2MLRrqDN
         FIxstyRCYYlTOVvaIe2CgmwPzbsxzwHbUYNVgcnuMEQ0uZ4DtVtCYmGYbsUs9bL2Heye
         G6IqAcp3WTV0tgN1xy1upWpnBv8SX1rJzvJBQGqP+JZN27GH4oj9VoUevf7nShd8wUXb
         G0tA==
X-Gm-Message-State: APjAAAU78VQxAs9HIC8CyVTAMxvgNLJv1vs51vwEB4Zn8MlJIhycOH1M
        +ogXovC23NtJ354L3CdWL9TCMUV5XiuMBA==
X-Google-Smtp-Source: APXvYqzbhA+xBdttbC/eagKzPwzhTxfHzX1VmM0j6XXxt7+wFN6X/uitsJN5fY+H8zcirwb9kXlOs0TvEG1Ipw==
X-Received: by 2002:a63:364d:: with SMTP id d74mr594977pga.408.1573869358448;
 Fri, 15 Nov 2019 17:55:58 -0800 (PST)
Date:   Fri, 15 Nov 2019 17:55:54 -0800
Message-Id: <20191116015554.51077-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] selftests: net: avoid ptl lock contention in tcp_mmap
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_mmap is used as a reference program for TCP rx zerocopy,
so it is important to point out some potential issues.

If multiple threads are concurrently using getsockopt(...
TCP_ZEROCOPY_RECEIVE), there is a chance the low-level mm
functions compete on shared ptl lock, if vma are arbitrary placed.

Instead of letting the mm layer place the chunks back to back,
this patch enforces an alignment so that each thread uses
a different ptl lock.

Performance measured on a 100 Gbit NIC, with 8 tcp_mmap clients
launched at the same time :

$ for f in {1..8}; do ./tcp_mmap -H 2002:a05:6608:290:: & done

In the following run, we reproduce the old behavior by requesting no alignment :

$ tcp_mmap -sz -C $((128*1024)) -a 4096
received 32768 MB (100 % mmap'ed) in 9.69532 s, 28.3516 Gbit
  cpu usage user:0.08634 sys:3.86258, 120.511 usec per MB, 171839 c-switches
received 32768 MB (100 % mmap'ed) in 25.4719 s, 10.7914 Gbit
  cpu usage user:0.055268 sys:21.5633, 659.745 usec per MB, 9065 c-switches
received 32768 MB (100 % mmap'ed) in 28.5419 s, 9.63069 Gbit
  cpu usage user:0.057401 sys:23.8761, 730.392 usec per MB, 14987 c-switches
received 32768 MB (100 % mmap'ed) in 28.655 s, 9.59268 Gbit
  cpu usage user:0.059689 sys:23.8087, 728.406 usec per MB, 18509 c-switches
received 32768 MB (100 % mmap'ed) in 28.7808 s, 9.55074 Gbit
  cpu usage user:0.066042 sys:23.4632, 718.056 usec per MB, 24702 c-switches
received 32768 MB (100 % mmap'ed) in 28.8259 s, 9.5358 Gbit
  cpu usage user:0.056547 sys:23.6628, 723.858 usec per MB, 23518 c-switches
received 32768 MB (100 % mmap'ed) in 28.8808 s, 9.51767 Gbit
  cpu usage user:0.059357 sys:23.8515, 729.703 usec per MB, 14691 c-switches
received 32768 MB (100 % mmap'ed) in 28.8879 s, 9.51534 Gbit
  cpu usage user:0.047115 sys:23.7349, 725.769 usec per MB, 21773 c-switches

New behavior (automatic alignment based on Hugepagesize),
we can see the system overhead being dramatically reduced.

$ tcp_mmap -sz -C $((128*1024))
received 32768 MB (100 % mmap'ed) in 13.5339 s, 20.3103 Gbit
  cpu usage user:0.122644 sys:3.4125, 107.884 usec per MB, 168567 c-switches
received 32768 MB (100 % mmap'ed) in 16.0335 s, 17.1439 Gbit
  cpu usage user:0.132428 sys:3.55752, 112.608 usec per MB, 188557 c-switches
received 32768 MB (100 % mmap'ed) in 17.5506 s, 15.6621 Gbit
  cpu usage user:0.155405 sys:3.24889, 103.891 usec per MB, 226652 c-switches
received 32768 MB (100 % mmap'ed) in 19.1924 s, 14.3222 Gbit
  cpu usage user:0.135352 sys:3.35583, 106.542 usec per MB, 207404 c-switches
received 32768 MB (100 % mmap'ed) in 22.3649 s, 12.2906 Gbit
  cpu usage user:0.142429 sys:3.53187, 112.131 usec per MB, 250225 c-switches
received 32768 MB (100 % mmap'ed) in 22.5336 s, 12.1986 Gbit
  cpu usage user:0.140654 sys:3.61971, 114.757 usec per MB, 253754 c-switches
received 32768 MB (100 % mmap'ed) in 22.5483 s, 12.1906 Gbit
  cpu usage user:0.134035 sys:3.55952, 112.718 usec per MB, 252997 c-switches
received 32768 MB (100 % mmap'ed) in 22.6442 s, 12.139 Gbit
  cpu usage user:0.126173 sys:3.71251, 117.147 usec per MB, 253728 c-switches

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Arjun Roy <arjunroy@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 58 +++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 0e73a30f0c2262e62a5ed1e2db6c7c8977bf44fa..5bb370a0857ec8a24916f583be5374183a9aefc8 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -82,7 +82,9 @@ static int zflg; /* zero copy option. (MSG_ZEROCOPY for sender, mmap() for recei
 static int xflg; /* hash received data (simple xor) (-h option) */
 static int keepflag; /* -k option: receiver shall keep all received file in memory (no munmap() calls) */
 
-static int chunk_size  = 512*1024;
+static size_t chunk_size  = 512*1024;
+
+static size_t map_align;
 
 unsigned long htotal;
 
@@ -118,6 +120,9 @@ void hash_zone(void *zone, unsigned int length)
 	htotal = temp;
 }
 
+#define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
+#define ALIGN_PTR_UP(p, ptr_align_to)	((typeof(p))ALIGN_UP((unsigned long)(p), ptr_align_to))
+
 void *child_thread(void *arg)
 {
 	unsigned long total_mmap = 0, total = 0;
@@ -126,6 +131,7 @@ void *child_thread(void *arg)
 	int flags = MAP_SHARED;
 	struct timeval t0, t1;
 	char *buffer = NULL;
+	void *raddr = NULL;
 	void *addr = NULL;
 	double throughput;
 	struct rusage ru;
@@ -142,9 +148,13 @@ void *child_thread(void *arg)
 		goto error;
 	}
 	if (zflg) {
-		addr = mmap(NULL, chunk_size, PROT_READ, flags, fd, 0);
-		if (addr == (void *)-1)
+		raddr = mmap(NULL, chunk_size + map_align, PROT_READ, flags, fd, 0);
+		if (raddr == (void *)-1) {
+			perror("mmap");
 			zflg = 0;
+		} else {
+			addr = ALIGN_PTR_UP(raddr, map_align);
+		}
 	}
 	while (1) {
 		struct pollfd pfd = { .fd = fd, .events = POLLIN, };
@@ -222,7 +232,7 @@ void *child_thread(void *arg)
 	free(buffer);
 	close(fd);
 	if (zflg)
-		munmap(addr, chunk_size);
+		munmap(raddr, chunk_size + map_align);
 	pthread_exit(0);
 }
 
@@ -303,6 +313,30 @@ static void do_accept(int fdlisten)
 	}
 }
 
+/* Each thread should reserve a big enough vma to avoid
+ * spinlock collisions in ptl locks.
+ * This size is 2MB on x86_64, and is exported in /proc/meminfo.
+ */
+static unsigned long default_huge_page_size(void)
+{
+	FILE *f = fopen("/proc/meminfo", "r");
+	unsigned long hps = 0;
+	size_t linelen = 0;
+	char *line = NULL;
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+	free(line);
+	fclose(f);
+	return hps;
+}
+
 int main(int argc, char *argv[])
 {
 	struct sockaddr_storage listenaddr, addr;
@@ -314,7 +348,7 @@ int main(int argc, char *argv[])
 	int sflg = 0;
 	int mss = 0;
 
-	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:")) != -1) {
+	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
@@ -354,10 +388,24 @@ int main(int argc, char *argv[])
 		case 'P':
 			max_pacing_rate = atoi(optarg) ;
 			break;
+		case 'C':
+			chunk_size = atol(optarg);
+			break;
+		case 'a':
+			map_align = atol(optarg);
+			break;
 		default:
 			exit(1);
 		}
 	}
+	if (!map_align) {
+		map_align = default_huge_page_size();
+		/* if really /proc/meminfo is not helping,
+		 * we use the default x86_64 hugepagesize.
+		 */
+		if (!map_align)
+			map_align = 2*1024*1024;
+	}
 	if (sflg) {
 		int fdlisten = socket(cfg_family, SOCK_STREAM, 0);
 
-- 
2.24.0.432.g9d3f5f5b63-goog

