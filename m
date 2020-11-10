Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03EF2ADDCA
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgKJSH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:07:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730504AbgKJSH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605031646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DhGEWOUCw6Y5w7w85ABenFAQ6PkZ6O0n2/ot5sVRJt4=;
        b=QAKaE8eLiOjiJPeFyIPGisaCpvSfgnvUBWk2e70hgvA2E/arOr0yUo+pbFH+xD+Q0w7HXj
        jT4dcy0AMF8ObsiehMTDK44i34a1CrAwW7///FthAhS5LbdgNIHTxWpHJu/HhiRXdI/JhK
        fjskjNTQfjU7sG7prxXwHFLNudOMHp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-IyGqkGDQN26k-Y3d0MYp8w-1; Tue, 10 Nov 2020 13:07:24 -0500
X-MC-Unique: IyGqkGDQN26k-Y3d0MYp8w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD5051074654;
        Tue, 10 Nov 2020 18:07:22 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F1B55D9D2;
        Tue, 10 Nov 2020 18:07:21 +0000 (UTC)
Date:   Tue, 10 Nov 2020 19:07:19 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201110180719.GA1559650@localhost>
References: <20201110061019.519589-1-vinicius.gomes@intel.com>
 <20201110061019.519589-4-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110061019.519589-4-vinicius.gomes@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 10:10:19PM -0800, Vinicius Costa Gomes wrote:
> i225 has support for PCIe PTM, which allows us to implement support
> for the PTP_SYS_OFFSET_PRECISE ioctl(), implemented in the driver via
> the getcrosststamp() function.

Would it be possible to provide the PTM measurements with the
PTP_SYS_OFFSET_EXTENDED ioctl instead of PTP_SYS_OFFSET_PRECISE?

As I understand it, PTM is not cross timestamping. It's basically
NTP over PCIe, which provides four timestamps with each "dialog". From
the other constants added to the header file it looks like they could
all be obtained and then they could be converted to the triplets
returned by the EXTENDED ioctl.

The main advantage would be that it would provide applications with
the round trip time, which is important to estimate the maximum error
in the measurement. As your example phc2sys output shows, with the
PRECISE ioctl the delay is 0, which is misleading here.

I suspect the estimate would be valid only when the NIC is connected
directly to the PTM root (PCI root complex). Is it possible to get the
timestamps or delay from PTM-capable switches on the path between CPU
and NIC? Also, how frequent can be the PTM dialogs? Could they be
performed synchronously in the ioctl?

-- 
Miroslav Lichvar

