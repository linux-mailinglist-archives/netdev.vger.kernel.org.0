Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E319158B
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 10:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHRIbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 04:31:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfHRIbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 04:31:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7I8UAkQ045583;
        Sun, 18 Aug 2019 08:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=OscEuJNSgaecc7omNE4pQTG5ugKKHTX9RKDQmcCtGr8=;
 b=VmfD0lZbcw1KI7nt0/A4dxSbgisrKmDi0ksS4DOvJSPFmZguw8QqN2r6SDm0Z6wBNXmX
 G9BAwNYAcfAOXkDya1jgpQlSWYNjdB+cjqm5KpmO9/O5DiYiytDKpaY/fxumu/OnzHuy
 bqVLfnlthkywEusuaLChoXe8DikNC9QC5x70lHKijTiX8EYQ58fAgNB/Sehg3d3xadve
 cIvZ77/epLNw47iZhE+9dRhe/nInKAarpbCUqO2bxH8hlMTOBZF9b3hDtUoKNAdhHiBj
 ZX0/GJSPhIZwysvofZ/ZXsZfA25bQwi/C6L147375Qu19zddOcs0YzKkSOVJ99Yzhu/L 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uea7qawt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Aug 2019 08:31:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7I8S93Q053923;
        Sun, 18 Aug 2019 08:31:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ue8wx3qu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Aug 2019 08:31:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7I8V1h2012172;
        Sun, 18 Aug 2019 08:31:01 GMT
MIME-Version: 1.0
Message-ID: <c45b306e-c67b-49f5-8fe8-3913557a8774@default>
Date:   Sun, 18 Aug 2019 01:31:00 -0700 (PDT)
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     <xen-devel@lists.xenproject.org>
Cc:     <netdev@vger.kernel.org>, <jgross@suse.com>,
        Joe Jin <joe.jin@oracle.com>
Subject: Question on xen-netfront code to fix a potential ring buffer
 corruption
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9352 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908180094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9352 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908180094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Would you please help confirm why the condition at line 908 is ">=3D"?

In my opinion, we would only hit "skb_shinfo(skb)->nr_frag =3D=3D MAX_SKB_F=
RAGS" at
line 908.

890 static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
891                                   struct sk_buff *skb,
892                                   struct sk_buff_head *list)
893 {
894         RING_IDX cons =3D queue->rx.rsp_cons;
895         struct sk_buff *nskb;
896=20
897         while ((nskb =3D __skb_dequeue(list))) {
898                 struct xen_netif_rx_response *rx =3D
899                         RING_GET_RESPONSE(&queue->rx, ++cons);
900                 skb_frag_t *nfrag =3D &skb_shinfo(nskb)->frags[0];
901=20
902                 if (skb_shinfo(skb)->nr_frags =3D=3D MAX_SKB_FRAGS) {
903                         unsigned int pull_to =3D NETFRONT_SKB_CB(skb)->=
pull_to;
904=20
905                         BUG_ON(pull_to < skb_headlen(skb));
906                         __pskb_pull_tail(skb, pull_to - skb_headlen(skb=
));
907                 }
908                 if (unlikely(skb_shinfo(skb)->nr_frags >=3D MAX_SKB_FRA=
GS)) {
909                         queue->rx.rsp_cons =3D ++cons;
910                         kfree_skb(nskb);
911                         return ~0U;
912                 }
913=20
914                 skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
915                                 skb_frag_page(nfrag),
916                                 rx->offset, rx->status, PAGE_SIZE);
917=20
918                 skb_shinfo(nskb)->nr_frags =3D 0;
919                 kfree_skb(nskb);
920         }
921=20
922         return cons;
923 }


The reason that I ask about this is because I am considering below patch to
avoid a potential xen-netfront ring buffer corruption.

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 8d33970..48a2162 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -906,7 +906,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue=
 *queue,
                        __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
                }
                if (unlikely(skb_shinfo(skb)->nr_frags >=3D MAX_SKB_FRAGS))=
 {
-                       queue->rx.rsp_cons =3D ++cons;
+                       queue->rx.rsp_cons =3D cons + skb_queue_len(list) +=
 1;
                        kfree_skb(nskb);
                        return ~0U;
                }


If there is skb left in list when we return ~0U, queue->rx.rsp_cons may be =
set
incorrectly.

While I am trying to make up a case that would hit the corruption, I could =
not
explain why (unlikely(skb_shinfo(skb)->nr_frags >=3D MAX_SKB_FRAGS)), but n=
ot
just "=3D=3D". Perhaps __pskb_pull_tail() may fail although pull_to is less=
 than
skb_headlen(skb).

Thank you very much!

Dongli Zhang
