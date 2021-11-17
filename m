Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3225454B3B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhKQQqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:46:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238462AbhKQQqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 11:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Qc+7Yo2MTcFX369pYUB99wyCjSPEpzsyXkN1VXuBDc=;
        b=iTxgTsaEijqxTn5721iazV5pbceAmQVXllqXimO0MDoonseIAwfykYmf0VJF0CX6QzqLOg
        jma0d2NPIYAiJm4GUVdDceAz6zayJei258Tcw45d2Gx4cjMpJRxDND8Sc3Md5joNnSLkPT
        gXX0QDEU8YbUoQtbZ/bOIH8RoQoF17M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-HlDeGTP6OFSYv-6Lh_VDSw-1; Wed, 17 Nov 2021 11:43:07 -0500
X-MC-Unique: HlDeGTP6OFSYv-6Lh_VDSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0F9080A5CA;
        Wed, 17 Nov 2021 16:43:05 +0000 (UTC)
Received: from localhost (unknown [10.39.193.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5B175D9DE;
        Wed, 17 Nov 2021 16:43:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: vfio migration discussions (was: [PATCH V2 mlx5-next 00/14] Add
 mlx5 live migration driver)
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20211019105838.227569-1-yishaih@nvidia.com>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Wed, 17 Nov 2021 17:42:58 +0100
Message-ID: <87mtm2loml.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, here's the contents (as of 2021-11-17 16:30 UTC) of the etherpad at
https://etherpad.opendev.org/p/VFIOMigrationDiscussions -- in the hope
of providing a better starting point for further discussion (I know that
discussions are still ongoing in other parts of this thread; but
frankly, I'm getting a headache trying to follow them, and I think it
would be beneficial to concentrate on the fundamental questions
first...)

VFIO migration: current state and open questions

Current status
  * Linux
    * uAPI has been merged with a8a24f3f6e38 ("vfio: UAPI for migration
    interface for device state") in 5.8
      * no kernel user of the uAPI merged
      * Several out of tree drivers apparently
    * support for mlx5 currently on the list (latest:
    https://lore.kernel.org/all/20211027095658.144468-1-yishaih@nvidia.com/
    with discussion still happening on older versions)
    * support for HiSilicon ACC devices is on the list too. Adds support
    for HiSilicon crypto accelerator VF device live migration. These are
    simple DMA queue based PCIe integrated endpoint devices. No support
    for P2P and doesn't use DMA for migration. <latest:
    https://lore.kernel.org/lkml/20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com/>
  * QEMU
    * basic support added in 5.2, some fixes later
      * support for vfio-pci only so far, still experimental
      ("x-enable-migration") as of 6.2
      * Only tested with out of tree drivers
  * other software?

Problems/open questions
  * Are the status bits currently defined in the uAPI
  (_RESUMING/_SAVING/_RUNNING) sufficient to express all states we need?
  * What does clearing _RUNNING imply? In particular, does it mean that
  the device is frozen, or are some operations still permitted?
  * various points brought up: P2P, SET_IRQS, ... <please summarize :)>:
    * P2P DMA support between devices requires an additional HW control
    state where the device can receive but not transmit DMA
    * No definition of what HW needs to preserve when RESUMING toggles
    off - (eg today SET_IRQS must work, what else?).
    * In general, how do IRQs work with future non-trapping IMS?
    * Dealing with pending IOMMU PRI faults during migration
  * Problems identified with the !RUNNING state:
    * When there are multiple devices in a user context (VM), we can't
    atomically move all devices to the !_RUNNING state concurently.
      * Suggests the current uAPI has a usage restriction for
      environments that do not make use of peer-to-peer DMA (ie. we
      can't have a device generating DMA to a p2p target that cannot
      accept it - especially if error response from target can generate
      host fatal conditions)
      * Possible userspace implications:
        * VMs could be limited to a single device to guarantee that no
        p2p exists - non-vfio devices generating physical p2p DMA in the
        future is a concern
        * Hypervisor may skip creating p2p DMA mappings, creating a
        choice whether the VM supports migration or p2p
      * Jason proposed a new NDMA (no-dma) state that seems to match the
      mlx5 implementation of "quiesce" vs "freeze" states, where NDMA
      would indicate the device cannot generate DMA or interrupts such
      that once userspace places all devices into the (NDMA | RUNNING)
      state the environment is fully quiesced.  A flag or capability on
      the migration region could indicate support for this feature.
      * Alex proposed that this could be equally resolved within the
      current device states if !RUNNING becomes the quiescent point
      where the device stops generating DMA and interrupts, with a
      requirement that the user moves all devices to !RUNNING before
      collecting device migration data (as indicated by reading
      pending_bytes) or else risk corrupting the migration data, which
      the device could indicate via an errno in the migration process.
      A flag or capability would still be required to indicate this
      support.
        * Jason does not favor this approach, objecting that the mode
        transition is implicit, and still needs qemu changes anyhow
    * In general, what operations or accesses is the user restricted
    from performing on the device while !RUNNING
      * Jason has proposed very restricted access (essentially none
      beyond the migration region itself), including no MMIO access
      <20211028234750.GP2744544@nvidia.com>  This essentially imposes
      device transmission to an intermediate state between SAVING and
      RUNNING.
        * Alex requested a formal uAPI update defining what accesses are
        allowed, including which regions and ioctls.
        * The existing uAPI does not require any such transition to a
        "null" state or TBD new device state bit.  QEMU currently
        expects access to config space and the ability to call SET_IRQS
        and create  mmaps while in the RESUMING state, without the
        RUNNING bit set.  Restoring MSI-X interrupt configuration
        necessarily requires MMIO access to the device.
        * Jason suggested a new device state bit and user protocol to
        account for this, where the device is in a !RUNNING and
        !RESTORING, but to some degree becomes manipulable via device
        regions and ioctls.  No compatibility mechanism proposed.
        * Alex suggested that this is potentially supportable via a spec
        clarification that requires the device migration data to be
        written to completion before userspace performs other region or
        ioctl access to the device. (mlx5's driver is designed to not
        inspect the migration blob itself, so it can't detect the
        "end". The migration blob is finished when mlx5 sees RESUMING
        clear.)
    * PRI into the guest (guest user process SVA) has a sequencing
    problem with RUNNING - can not migrate a vIOMMU in the middle of a
    page fault, must stop and flush faults before stopping vCPUs
  * The uAPI could benefit from some more detailed documentation
  (e.g. how to use it, what to do in edge cases, ...) outside of the
  header file.
  * Trying to use the mlx5 support currently on the list has unearthed
  some problems in QEMU <please summarize :)>
  * Discussion regarding dirty tracking and how much it should be
  controlled by user space still ongoing
  * General questions:
    * How much do we want to change the uAPI and/or the documentation to
    accommodate what QEMU has implemented so far?
    * How much do we want to change QEMU?

Possible solutions
  * uAPI
    * fine as is, or
    * needs some clarifications, or
    * needs rework, which might mean a v2
  * QEMU
    * fine as is (modulo bugfixes), or
    * needs some rework, but not impacting the uAPI, or
    * needs some rework, which also needs some changes in the uAPI
  * Suggested approach:
    * Work on the documentation, and try to come up with some more
    HW-centric docs
    * Depending on that, decide how many changes we want/need to do in
    QEMU

