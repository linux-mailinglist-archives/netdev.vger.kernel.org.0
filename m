Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F9411EC4E
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLMU5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:57:15 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:47911 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:57:14 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Macf4-1i8Ard27AI-00c9CC; Fri, 13 Dec 2019 21:56:47 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeff Layton <jeff.layton@primarydata.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 16/24] nfs: use time64_t internally
Date:   Fri, 13 Dec 2019 21:53:44 +0100
Message-Id: <20191213205417.3871055-7-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zU579cGLtM2BwOX2L6/aBNJm2mG2LNJX5rJZryF/qIu0irH6BiF
 ZY/JjteGsij9vQsWk3Dj+aew3UprVZlgGfztwzz6xul+TAEV6K79wojrGUoIE8ZCzm5WE6j
 8KBq0afuO2eCyU1AwnwovRQvXboZv/LEA8qVC0DirLx+zt/KcYbbbSL8JVLt6310oGaM2Kk
 wTDJ99kbGOJq5qwuAogxQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EWtUItQVyk0=:EOA+z3Iv+IOZwyevr7KVIP
 jXwQMOg+cf5aR7Jh0dtXDGqvIqvAiYH42nbT4N3oC7mHEoSEXLoQFNTdMufsa4OIewrZoMCh2
 z14/rjfPVlV7A76zSvP2NU+ifgLGFT4RtGHITc9KGom0dLiYiFVhj1LXcTNUbZGo3jnbDQfyF
 lhmR1Pd5Yarq/LR56qFXgJ+TtWEiiCK1ZO9FT9gQaAGzJ6erSY2mgrgIiPQ2cbUAS0gXAofRu
 tlHCJXgIviZNGo2EqYzHEEIfpDAwf4BFarVXnPd1Z56HzTMbnREo3yws4u5+3hXPntj7EVOKp
 /PGwgcytxz55P/iDOI7hPx8PB6F/GMe1gcFESzrTAu+ExTDcGCRiIyMP6ziYU/IfmZ4YsHAeE
 Fx9Z2P10MxSAZ/gqLW+zoKnMG/9t5Jwz7y1tVCUtRM4eHE0tT1bk45QT5+0EgLuCWAZrIxeBX
 Ohe3yU0QyP7OVGZ0PnSbd8jUENV5oImZlviqvOFv4oFtGA3O7DqSprNeWiogEpn2KMkyL+nB+
 cyPWeOYbj6ZzvtMEPiQTL3/+OtPBXQQxAZEoUIKe2FJgrdCJYT7db9MwpT6KJ9JU2RHxpfvBk
 D/M18UAr3iZKTtWBuXwO75l46mCt8+lOFuu+9Yzh7L8pKgWEt5gLasRYxuHCfa5axA4Z8fR9W
 9h/ibWkPpGhTROhXarsgmgq5Su2Jz10DR01iRLwEIlKT9pCr/qLoHDLc6Y7XZwtaLTFB3Pfpz
 6ZXkXkvXy8c4da0vU093frsZO8cbMF/DZwjvYozTkWnRr5fF9JTK2gOmONFEMf8ifaSrgiecN
 fapJ4Wkjez2Pjkn25MwYRSnoKzJCaA2lUEOwHtMsf9ks8XSU4VhqPVDcR82w3vEhdBGlHp3Mq
 /Ap8N6uIIZ8R3+xZbJ9g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timestamps for the cache are all in boottime seconds, so they
don't overflow 32-bit values, but the use of time_t is deprecated
because it generally does overflow when used with wall-clock time.

There are multiple possible ways of avoiding it:

- leave time_t, which is safe here, but forces others to
  look into this code to determine that it is over and over.

- use a more generic type, like 'int' or 'long', which is known
  to be sufficient here but loses the documentation of referring
  to timestamps

- use ktime_t everywhere, and convert into seconds in the few
  places where we want realtime-seconds. The conversion is
  sometimes expensive, but not more so than the conversion we
  do today.

- use time64_t to clarify that this code is safe. Nothing would
  change for 64-bit architectures, but it is slightly less
  efficient on 32-bit architectures.

Without a clear winner of the three approaches above, this picks
the last one, favouring readability over a small performance
loss on 32-bit architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/sunrpc/cache.h      | 42 +++++++++++++++++--------------
 net/sunrpc/auth_gss/svcauth_gss.c |  2 +-
 net/sunrpc/cache.c                | 16 ++++++------
 net/sunrpc/svcauth_unix.c         | 10 ++++----
 4 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index f8603724fbee..0f64de7caa39 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -45,8 +45,8 @@
  */
 struct cache_head {
 	struct hlist_node	cache_list;
-	time_t		expiry_time;	/* After time time, don't use the data */
-	time_t		last_refresh;   /* If CACHE_PENDING, this is when upcall was
+	time64_t	expiry_time;	/* After time time, don't use the data */
+	time64_t	last_refresh;   /* If CACHE_PENDING, this is when upcall was
 					 * sent, else this is when update was
 					 * received, though it is alway set to
 					 * be *after* ->flush_time.
@@ -95,22 +95,22 @@ struct cache_detail {
 	/* fields below this comment are for internal use
 	 * and should not be touched by cache owners
 	 */
-	time_t			flush_time;		/* flush all cache items with
+	time64_t		flush_time;		/* flush all cache items with
 							 * last_refresh at or earlier
 							 * than this.  last_refresh
 							 * is never set at or earlier
 							 * than this.
 							 */
 	struct list_head	others;
-	time_t			nextcheck;
+	time64_t		nextcheck;
 	int			entries;
 
 	/* fields for communication over channel */
 	struct list_head	queue;
 
 	atomic_t		writers;		/* how many time is /channel open */
-	time_t			last_close;		/* if no writers, when did last close */
-	time_t			last_warn;		/* when we last warned about no writers */
+	time64_t		last_close;		/* if no writers, when did last close */
+	time64_t		last_warn;		/* when we last warned about no writers */
 
 	union {
 		struct proc_dir_entry	*procfs;
@@ -147,18 +147,22 @@ struct cache_deferred_req {
  * timestamps kept in the cache are expressed in seconds
  * since boot.  This is the best for measuring differences in
  * real time.
+ * This reimplemnts ktime_get_boottime_seconds() in a slightly
+ * faster but less accurate way. When we end up converting
+ * back to wallclock (CLOCK_REALTIME), that error often
+ * cancels out during the reverse operation.
  */
-static inline time_t seconds_since_boot(void)
+static inline time64_t seconds_since_boot(void)
 {
-	struct timespec boot;
-	getboottime(&boot);
-	return get_seconds() - boot.tv_sec;
+	struct timespec64 boot;
+	getboottime64(&boot);
+	return ktime_get_real_seconds() - boot.tv_sec;
 }
 
-static inline time_t convert_to_wallclock(time_t sinceboot)
+static inline time64_t convert_to_wallclock(time64_t sinceboot)
 {
-	struct timespec boot;
-	getboottime(&boot);
+	struct timespec64 boot;
+	getboottime64(&boot);
 	return boot.tv_sec + sinceboot;
 }
 
@@ -273,7 +277,7 @@ static inline int get_uint(char **bpp, unsigned int *anint)
 	return 0;
 }
 
-static inline int get_time(char **bpp, time_t *time)
+static inline int get_time(char **bpp, time64_t *time)
 {
 	char buf[50];
 	long long ll;
@@ -287,20 +291,20 @@ static inline int get_time(char **bpp, time_t *time)
 	if (kstrtoll(buf, 0, &ll))
 		return -EINVAL;
 
-	*time = (time_t)ll;
+	*time = ll;
 	return 0;
 }
 
-static inline time_t get_expiry(char **bpp)
+static inline time64_t get_expiry(char **bpp)
 {
-	time_t rv;
-	struct timespec boot;
+	time64_t rv;
+	struct timespec64 boot;
 
 	if (get_time(bpp, &rv))
 		return 0;
 	if (rv < 0)
 		return 0;
-	getboottime(&boot);
+	getboottime64(&boot);
 	return rv - boot.tv_sec;
 }
 
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 0c3e22838ddf..311181720d79 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -203,7 +203,7 @@ static int rsi_parse(struct cache_detail *cd,
 	char *ep;
 	int len;
 	struct rsi rsii, *rsip = NULL;
-	time_t expiry;
+	time64_t expiry;
 	int status = -EINVAL;
 
 	memset(&rsii, 0, sizeof(rsii));
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index f740cb51802a..d996bf872a7c 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -42,7 +42,7 @@ static bool cache_listeners_exist(struct cache_detail *detail);
 
 static void cache_init(struct cache_head *h, struct cache_detail *detail)
 {
-	time_t now = seconds_since_boot();
+	time64_t now = seconds_since_boot();
 	INIT_HLIST_NODE(&h->cache_list);
 	h->flags = 0;
 	kref_init(&h->ref);
@@ -139,10 +139,10 @@ EXPORT_SYMBOL_GPL(sunrpc_cache_lookup_rcu);
 
 static void cache_dequeue(struct cache_detail *detail, struct cache_head *ch);
 
-static void cache_fresh_locked(struct cache_head *head, time_t expiry,
+static void cache_fresh_locked(struct cache_head *head, time64_t expiry,
 			       struct cache_detail *detail)
 {
-	time_t now = seconds_since_boot();
+	time64_t now = seconds_since_boot();
 	if (now <= detail->flush_time)
 		/* ensure it isn't immediately treated as expired */
 		now = detail->flush_time + 1;
@@ -274,7 +274,7 @@ int cache_check(struct cache_detail *detail,
 		    struct cache_head *h, struct cache_req *rqstp)
 {
 	int rv;
-	long refresh_age, age;
+	time64_t refresh_age, age;
 
 	/* First decide return status as best we can */
 	rv = cache_is_valid(h);
@@ -288,7 +288,7 @@ int cache_check(struct cache_detail *detail,
 			rv = -ENOENT;
 	} else if (rv == -EAGAIN ||
 		   (h->expiry_time != 0 && age > refresh_age/2)) {
-		dprintk("RPC:       Want update, refage=%ld, age=%ld\n",
+		dprintk("RPC:       Want update, refage=%lld, age=%lld\n",
 				refresh_age, age);
 		if (!test_and_set_bit(CACHE_PENDING, &h->flags)) {
 			switch (cache_make_upcall(detail, h)) {
@@ -1404,7 +1404,7 @@ static int c_show(struct seq_file *m, void *p)
 		return cd->cache_show(m, cd, NULL);
 
 	ifdebug(CACHE)
-		seq_printf(m, "# expiry=%ld refcnt=%d flags=%lx\n",
+		seq_printf(m, "# expiry=%lld refcnt=%d flags=%lx\n",
 			   convert_to_wallclock(cp->expiry_time),
 			   kref_read(&cp->ref), cp->flags);
 	cache_get(cp);
@@ -1477,7 +1477,7 @@ static ssize_t read_flush(struct file *file, char __user *buf,
 	char tbuf[22];
 	size_t len;
 
-	len = snprintf(tbuf, sizeof(tbuf), "%lu\n",
+	len = snprintf(tbuf, sizeof(tbuf), "%llu\n",
 			convert_to_wallclock(cd->flush_time));
 	return simple_read_from_buffer(buf, count, ppos, tbuf, len);
 }
@@ -1488,7 +1488,7 @@ static ssize_t write_flush(struct file *file, const char __user *buf,
 {
 	char tbuf[20];
 	char *ep;
-	time_t now;
+	time64_t now;
 
 	if (*ppos || count > sizeof(tbuf)-1)
 		return -EINVAL;
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 5c04ba7d456b..04aa80a2d752 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -166,7 +166,7 @@ static void ip_map_request(struct cache_detail *cd,
 }
 
 static struct ip_map *__ip_map_lookup(struct cache_detail *cd, char *class, struct in6_addr *addr);
-static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm, struct unix_domain *udom, time_t expiry);
+static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm, struct unix_domain *udom, time64_t expiry);
 
 static int ip_map_parse(struct cache_detail *cd,
 			  char *mesg, int mlen)
@@ -187,7 +187,7 @@ static int ip_map_parse(struct cache_detail *cd,
 
 	struct ip_map *ipmp;
 	struct auth_domain *dom;
-	time_t expiry;
+	time64_t expiry;
 
 	if (mesg[mlen-1] != '\n')
 		return -EINVAL;
@@ -308,7 +308,7 @@ static inline struct ip_map *ip_map_lookup(struct net *net, char *class,
 }
 
 static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm,
-		struct unix_domain *udom, time_t expiry)
+		struct unix_domain *udom, time64_t expiry)
 {
 	struct ip_map ip;
 	struct cache_head *ch;
@@ -328,7 +328,7 @@ static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm,
 }
 
 static inline int ip_map_update(struct net *net, struct ip_map *ipm,
-		struct unix_domain *udom, time_t expiry)
+		struct unix_domain *udom, time64_t expiry)
 {
 	struct sunrpc_net *sn;
 
@@ -491,7 +491,7 @@ static int unix_gid_parse(struct cache_detail *cd,
 	int rv;
 	int i;
 	int err;
-	time_t expiry;
+	time64_t expiry;
 	struct unix_gid ug, *ugp;
 
 	if (mesg[mlen - 1] != '\n')
-- 
2.20.0

