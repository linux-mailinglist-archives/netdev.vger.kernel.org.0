Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52CE676C07
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 11:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjAVKL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 05:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjAVKLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 05:11:52 -0500
X-Greylist: delayed 318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 Jan 2023 02:11:03 PST
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C109C1D90F;
        Sun, 22 Jan 2023 02:11:03 -0800 (PST)
Received: from lenovo-t14s.redhat.com ([82.142.8.70]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MqINP-1oy0341K9z-00nPdI; Sun, 22 Jan 2023 11:05:33 +0100
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH 4/4] virtio_net: fix virtnet_send_command() with vdpa_sim_net
Date:   Sun, 22 Jan 2023 11:05:26 +0100
Message-Id: <20230122100526.2302556-5-lvivier@redhat.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230122100526.2302556-1-lvivier@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YTjFLU1lj+k8vApmSwkjqxN3EBr0drRgQSUre+RfcDGSw4uTA+0
 fpObHvWK8k3li6YWyS80RiUZHOX8MywdgaDytn/6t8T+DiaynYAOSnUv/FWk1HaQEOmrj5S
 KrovGMPtwrXHOQlFb5ZB7KBF2sy6BQdtTORgHlq35jPyVn4D7dbru2lBJVeYHfpcThtGErb
 +Fr/sA0/vvb/ZKDcaf4ag==
UI-OutboundReport: notjunk:1;M01:P0:W/8CbaMJfHI=;CztS2YeNk03sPaZQmk0pcBJ6L43
 XcTq3jVYTR1mPvip15m9kRcm4gx/fCYvZXXAiserRgQ9GFMVi/1LZ0b4jQkbYecKpXXQ+1YOU
 rBpVaXPROlsifSO1bNiEiHYAbudG2KcSeHDa4oueEPlBlJpIcVfy5U+3ZlKYLxT5ZRzdg50Qs
 g/IdVtnBO6yU19WOFGc0dYdOtjbIpFy66HsEykChNF0WWHZQhrOOJ2WhiAuzsvuBRJTgO05cc
 GLWOboaYKXGeWF74daHubX+BlE1K7ZZS9qZ6sIRQ2qMZO+rA8owLFae2Y/cg3W80pIRcNgW47
 jkd67qMPk0vZjxCO9UrPIK3Tls1BKbZ2u91VxEMWay+YYAE1RqV/NhWBUjZ85vf/Jua4dzf9u
 UzzD3cflGJ9vqwlR003dHr1chEHCC6R+ff7po0WY+C8azbOlMMlJlx4lV5ntjVsWQkQgVzihl
 cgg+JKelqfGLSQlRJBSx6aNgedhV/zvuqXKnNPGdNSttYep61gKReoyF4gEDLnVmvpkLkjVzM
 nlV+b2ig0YvJfYiuFp4QMmD4FiCpy5+9MDcBhXTpaiIDFvMhaMsPdgwPCARDGRKYR8/7oPQku
 F5Nzmv3rfaax47qfuviRX2Dq8X+FsMmh0fbGYELuiT9zFEea8uCwaEwaW4BsNrsCbbzen8UtB
 xzMSe0bE+Kdl8LxR2gO5YF/TUzIUv4hfj3/YxuuEzA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_send_command() sends a command to the control virtqueue
by adding the command to the virtqueue, kicking the queue and waiting
in a loop.

The vdpa simulator simulates the control virqueue using a work queue:
the virqueue_kick() calls schedule_work() to start the queue processing.
But as virtnet_send_command() uses a loop, the scheduler cannot schedule
the workqueue and the virtqueue is never processed (and the command
never executed).

To fix that, replace in the loop the cpu_relax() by a schedule().

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 29b3cc72082d..546c0b2baaca 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2011,7 +2011,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
 	       !virtqueue_is_broken(vi->cvq) &&
 	       !time_after(jiffies, timeout))
-		cpu_relax();
+		schedule();
 
 	return vi->ctrl->status == VIRTIO_NET_OK;
 }
-- 
2.39.0

