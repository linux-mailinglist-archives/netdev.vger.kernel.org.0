Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B68120E9B
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 16:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfLPPxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 10:53:39 -0500
Received: from www62.your-server.de ([213.133.104.62]:35992 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfLPPxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 10:53:39 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igsgi-00089A-Q4; Mon, 16 Dec 2019 16:53:36 +0100
Date:   Mon, 16 Dec 2019 16:53:36 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: Print hint about ulimit when getting
 permission denied error
Message-ID: <20191216155336.GA28925@linux.fritz.box>
References: <20191216124031.371482-1-toke@redhat.com>
 <20191216145230.103c1f46@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216145230.103c1f46@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 02:52:30PM +0100, Jesper Dangaard Brouer wrote:
> On Mon, 16 Dec 2019 13:40:31 +0100
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
> > Probably the single most common error newcomers to XDP are stumped by is
> > the 'permission denied' error they get when trying to load their program
> > and 'ulimit -r' is set too low. For examples, see [0], [1].
> > 
> > Since the error code is UAPI, we can't change that. Instead, this patch
> > adds a few heuristics in libbpf and outputs an additional hint if they are
> > met: If an EPERM is returned on map create or program load, and geteuid()
> > shows we are root, and the current RLIMIT_MEMLOCK is not infinity, we
> > output a hint about raising 'ulimit -r' as an additional log line.
> > 
> > [0] https://marc.info/?l=xdp-newbies&m=157043612505624&w=2
> > [1] https://github.com/xdp-project/xdp-tutorial/issues/86
> > 
> > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> This is the top #1 issue users hit again-and-again, too bad we cannot
> change the return code as it is UAPI now.  Thanks for taking care of
> this mitigation.

It's an annoying error that comes up very often, agree, and tooling then
sets it to a high value / inf anyway as next step if it has the rights
to do so. Probably time to revisit the idea that if the user has the same
rights as being able to set setrlimit() anyway, we should just not account
for it ... incomplete hack:

 kernel/bpf/syscall.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b08c362f4e02..116581c32848 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -203,12 +203,17 @@ void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)

 static int bpf_charge_memlock(struct user_struct *user, u32 pages)
 {
-	unsigned long memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	unsigned long memlock_limit;

+	if (capable(CAP_SYS_RESOURCE))
+		return 0;
+
+	memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 	if (atomic_long_add_return(pages, &user->locked_vm) > memlock_limit) {
 		atomic_long_sub(pages, &user->locked_vm);
 		return -EPERM;
 	}
+
 	return 0;
 }

@@ -1339,12 +1344,12 @@ static void bpf_audit_prog(const struct bpf_prog *prog, unsigned int op)

 int __bpf_prog_charge(struct user_struct *user, u32 pages)
 {
-	unsigned long memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	unsigned long user_bufs;
+	unsigned long memlock_limit;

-	if (user) {
-		user_bufs = atomic_long_add_return(pages, &user->locked_vm);
-		if (user_bufs > memlock_limit) {
+	if (user && !capable(CAP_SYS_RESOURCE)) {
+		memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+		if (atomic_long_add_return(pages, &user->locked_vm) >
+		    memlock_limit) {
 			atomic_long_sub(pages, &user->locked_vm);
 			return -EPERM;
 		}
--
2.21.0
