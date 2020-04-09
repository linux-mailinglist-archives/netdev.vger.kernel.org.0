Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B51A396C
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgDIR5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgDIR5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 13:57:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80C9206E9;
        Thu,  9 Apr 2020 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586455026;
        bh=uQIvL/g2Pb5EQ1h5qThcFymNG+XiwxGMoVigKFwkbEk=;
        h=From:To:Cc:Subject:Date:From;
        b=HSpWlF5mjPtqmrO2Xu78kAN8jvBZ1VugZWpqWZvmo2DwZTlprUkxr94QIez/lsCCN
         oAnKJQWc3rIQZR7+D0b2IOmqVf+Y98n3D7CP8kzTdVJxyvXgxMXuMrG6E9M207Vumt
         m3w8xztI8kfaH8RPOBkZOTAIQcSWlnI3jkbQqzPM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, rdunlap@infradead.org,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: networking: convert DIM to RST
Date:   Thu,  9 Apr 2020 10:57:04 -0700
Message-Id: <20200409175704.305241-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Dynamic Interrupt Moderation doc to RST and
use the RST features like syntax highlight, function and
structure documentation, enumerations, table of contents.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{net_dim.txt => net_dim.rst}   | 106 +++++++++---------
 MAINTAINERS                                   |   1 +
 3 files changed, 58 insertions(+), 50 deletions(-)
 rename Documentation/networking/{net_dim.txt => net_dim.rst} (75%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 50133d9761c9..6538ede29661 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -22,6 +22,7 @@ Linux Networking Documentation
    z8530book
    msg_zerocopy
    failover
+   net_dim
    net_failover
    phy
    sfp-phylink
diff --git a/Documentation/networking/net_dim.txt b/Documentation/networking/net_dim.rst
similarity index 75%
rename from Documentation/networking/net_dim.txt
rename to Documentation/networking/net_dim.rst
index 9bdb7d5a3ba3..935b260b6566 100644
--- a/Documentation/networking/net_dim.txt
+++ b/Documentation/networking/net_dim.rst
@@ -1,28 +1,23 @@
+======================================================
 Net DIM - Generic Network Dynamic Interrupt Moderation
 ======================================================
 
-Author:
-	Tal Gilboa <talgi@mellanox.com>
-
+:Author: Tal Gilboa <talgi@mellanox.com>
 
 Contents
-=========
+========
 
-- Assumptions
-- Introduction
-- The Net DIM Algorithm
-- Registering a Network Device to DIM
-- Example
+.. contents:: :local:
 
-Part 0: Assumptions
-======================
+Assumptions
+===========
 
 This document assumes the reader has basic knowledge in network drivers
 and in general interrupt moderation.
 
 
-Part I: Introduction
-======================
+Introduction
+============
 
 Dynamic Interrupt Moderation (DIM) (in networking) refers to changing the
 interrupt moderation configuration of a channel in order to optimize packet
@@ -41,14 +36,15 @@ number of wanted packets per event. The Net DIM algorithm ascribes importance to
 increase bandwidth over reducing interrupt rate.
 
 
-Part II: The Net DIM Algorithm
-===============================
+Net DIM Algorithm
+=================
 
 Each iteration of the Net DIM algorithm follows these steps:
-1. Calculates new data sample.
-2. Compares it to previous sample.
-3. Makes a decision - suggests interrupt moderation configuration fields.
-4. Applies a schedule work function, which applies suggested configuration.
+
+#. Calculates new data sample.
+#. Compares it to previous sample.
+#. Makes a decision - suggests interrupt moderation configuration fields.
+#. Applies a schedule work function, which applies suggested configuration.
 
 The first two steps are straightforward, both the new and the previous data are
 supplied by the driver registered to Net DIM. The previous data is the new data
@@ -89,30 +85,40 @@ manoeuvre as it may provide partial data or ignore the algorithm suggestion
 under some conditions.
 
 
-Part III: Registering a Network Device to DIM
-==============================================
+Registering a Network Device to DIM
+===================================
+
+Net DIM API exposes the main function :c:func:`net_dim`.
+
+.. c:function:: void net_dim( struct dim *dim, struct dim_sample end_sample )
 
-Net DIM API exposes the main function net_dim(struct dim *dim,
-struct dim_sample end_sample). This function is the entry point to the Net
+This function is the entry point to the Net
 DIM algorithm and has to be called every time the driver would like to check if
 it should change interrupt moderation parameters. The driver should provide two
-data structures: struct dim and struct dim_sample. Struct dim
-describes the state of DIM for a specific object (RX queue, TX queue,
-other queues, etc.). This includes the current selected profile, previous data
-samples, the callback function provided by the driver and more.
-Struct dim_sample describes a data sample, which will be compared to the
-data sample stored in struct dim in order to decide on the algorithm's next
-step. The sample should include bytes, packets and interrupts, measured by
-the driver.
+data structures:
+
+.. c:type:: struct dim
+
+  Describes the state of DIM for a specific object (RX queue, TX queue,
+  other queues, etc.). This includes the current selected profile, previous
+  data samples, the callback function provided by the driver and more.
+
+.. c:type:: struct dim_sample
+
+  Describes a data sample, which will be compared to the data sample
+  stored in :c:type:`struct dim <dim>` in order to decide on the algorithm's next step.
+  The sample should include bytes, packets and interrupts, measured by
+  the driver.
 
 In order to use Net DIM from a networking driver, the driver needs to call the
 main net_dim() function. The recommended method is to call net_dim() on each
 interrupt. Since Net DIM has a built-in moderation and it might decide to skip
 iterations under certain conditions, there is no need to moderate the net_dim()
 calls as well. As mentioned above, the driver needs to provide an object of type
-struct dim to the net_dim() function call. It is advised for each entity
-using Net DIM to hold a struct dim as part of its data structure and use it
-as the main Net DIM API object. The struct dim_sample should hold the latest
+:c:type:`struct dim <dim>` to the net_dim() function call. It is advised for
+each entity using Net DIM to hold a :c:type:`struct dim <dim>` as part of its
+data structure and use it as the main Net DIM API object.
+The :c:type:`struct dim_sample <dim_sample>` should hold the latest
 bytes, packets and interrupts count. No need to perform any calculations, just
 include the raw data.
 
@@ -124,19 +130,19 @@ the data flow. After the work is done, Net DIM algorithm needs to be set to
 the proper state in order to move to the next iteration.
 
 
-Part IV: Example
-=================
+Example
+=======
 
 The following code demonstrates how to register a driver to Net DIM. The actual
 usage is not complete but it should make the outline of the usage clear.
 
-my_driver.c:
+.. code-block:: c
 
-#include <linux/dim.h>
+  #include <linux/dim.h>
 
-/* Callback for net DIM to schedule on a decision to change moderation */
-void my_driver_do_dim_work(struct work_struct *work)
-{
+  /* Callback for net DIM to schedule on a decision to change moderation */
+  void my_driver_do_dim_work(struct work_struct *work)
+  {
 	/* Get struct dim from struct work_struct */
 	struct dim *dim = container_of(work, struct dim,
 				       work);
@@ -145,11 +151,11 @@ void my_driver_do_dim_work(struct work_struct *work)
 
 	/* Signal net DIM work is done and it should move to next iteration */
 	dim->state = DIM_START_MEASURE;
-}
+  }
 
-/* My driver's interrupt handler */
-int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
-{
+  /* My driver's interrupt handler */
+  int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
+  {
 	...
 	/* A struct to hold current measured data */
 	struct dim_sample dim_sample;
@@ -162,13 +168,13 @@ int my_driver_handle_interrupt(struct my_driver_entity *my_entity, ...)
 	/* Call net DIM */
 	net_dim(&my_entity->dim, dim_sample);
 	...
-}
+  }
 
-/* My entity's initialization function (my_entity was already allocated) */
-int my_driver_init_my_entity(struct my_driver_entity *my_entity, ...)
-{
+  /* My entity's initialization function (my_entity was already allocated) */
+  int my_driver_init_my_entity(struct my_driver_entity *my_entity, ...)
+  {
 	...
 	/* Initiate struct work_struct with my driver's callback function */
 	INIT_WORK(&my_entity->dim.work, my_driver_do_dim_work);
 	...
-}
+  }
diff --git a/MAINTAINERS b/MAINTAINERS
index 9271068bde63..46a3a01b54b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5961,6 +5961,7 @@ M:	Tal Gilboa <talgi@mellanox.com>
 S:	Maintained
 F:	include/linux/dim.h
 F:	lib/dim/
+F:	Documentation/networking/net_dim.rst
 
 DZ DECSTATION DZ11 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@linux-mips.org>
-- 
2.25.1

