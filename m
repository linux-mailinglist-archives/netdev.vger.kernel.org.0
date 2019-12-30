Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19012CD61
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 08:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfL3HiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 02:38:16 -0500
Received: from mail-40132.protonmail.ch ([185.70.40.132]:50727 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfL3HiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 02:38:16 -0500
Date:   Mon, 30 Dec 2019 07:38:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1577691492;
        bh=z+SiGK+QrMcmAsFwhU3ikZGguzCumEioVzx4B5F75hk=;
        h=Date:To:From:Cc:Reply-To:Subject:Feedback-ID:From;
        b=EsSpAObH05ybrw6BjCQD2VwOvz8OPuXSFEoYJNl4kx8Oh/F+DRPrNAKRvnqrBikVF
         1n2ahyok+B/AkCXNx3/rJsvNFQBQUc1hC9mAoSzcOSDFyg3AbScnk/Wj0yYo7DmoZw
         YnTpp2k0AitX1uSPfitcoi40j6iU3bn2i5aq4Xbs=
To:     Netdev <netdev@vger.kernel.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "edumazet@google.com" <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the original logic of tcp_conn_request, the backlog parameter of the
listen system call and net.ipv4.tcp_max_syn_backlog are independent of
each other, which causes some confusion in the processing.

The backlog determines the maximum length of request_sock_queue, hereafter
referred to as backlog.

In the original design, if syn_cookies is not turned on, a quarter of
tcp_max_syn_backlog will be reserved for clients that have proven to
exist, mitigating syn attacks.

Suppose now that tcp_max_syn_backlog is 1000, but the backlog is only 200,
then 1000 >> 2 =3D 250, the backlog is used up by the syn attack, and the
above mechanism will not work.

Is tcp_max_syn_backlog used to limit the
maximum length of request_sock_queue?

Now suppose sycookie is enabled, backlog is 1000, and tcp_max_syn_backlog
is only 200. In this case tcp_max_syn_backlog will be useless.

Because syn_cookies is enabled, the tcp_max_syn_backlog logic will
be ignored, and the length of request_sock_queue will exceed
tcp_max_syn_backlog until the backlog.

I modified the original logic and set the minimum value in backlog and
tcp_max_syn_backlog as the maximum length limit of request_sock_queue.

Now there is only a unified limit.

The maximum length limit variable is "max_syn_backlog".

Use syn_cookies whenever max_syn_backlog is exceeded.

If syn_cookies is not enabled, a quarter of the max_syn_backlog queue is
reserved for hosts that have proven to exist.

In any case, request_sock_queue will not exceed max_syn_backlog.
When syn_cookies is not turned on, a quarter of the queue retention
will not be preempted.

Signed-off-by: AK Deng <ttttabcd@protonmail.com>
---
 net/ipv4/tcp_input.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88b987ca9ebb..190edaaa9dce 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6562,14 +6562,18 @@ int tcp_conn_request(struct request_sock_ops *rsk_o=
ps,
 =09struct request_sock *req;
 =09bool want_cookie =3D false;
 =09struct dst_entry *dst;
+=09int max_syn_backlog;
 =09struct flowi fl;

+=09max_syn_backlog =3D min(net->ipv4.sysctl_max_syn_backlog,
+=09=09=09      sk->sk_max_ack_backlog);
+
 =09/* TW buckets are converted to open requests without
 =09 * limitations, they conserve resources and peer is
 =09 * evidently real one.
 =09 */
 =09if ((net->ipv4.sysctl_tcp_syncookies =3D=3D 2 ||
-=09     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
+=09     inet_csk_reqsk_queue_len(sk) >=3D max_syn_backlog) && !isn) {
 =09=09want_cookie =3D tcp_syn_flood_action(sk, rsk_ops->slab_name);
 =09=09if (!want_cookie)
 =09=09=09goto drop;
@@ -6621,8 +6625,8 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops=
,
 =09if (!want_cookie && !isn) {
 =09=09/* Kill the following clause, if you dislike this way. */
 =09=09if (!net->ipv4.sysctl_tcp_syncookies &&
-=09=09    (net->ipv4.sysctl_max_syn_backlog - inet_csk_reqsk_queue_len(sk)=
 <
-=09=09     (net->ipv4.sysctl_max_syn_backlog >> 2)) &&
+=09=09    (max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
+=09=09     (max_syn_backlog >> 2)) &&
 =09=09    !tcp_peer_is_proven(req, dst)) {
 =09=09=09/* Without syncookies last quarter of
 =09=09=09 * backlog is filled with destinations,
--
2.24.0

