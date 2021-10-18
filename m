Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D72432997
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 00:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhJRWO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhJRWO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 18:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634595164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4/IVw5ot7pVSwKmbjdyY1BVdJkQ5fxOT1q2JMy6LDUw=;
        b=LEFku2WC/q7gwsu19MaxqXrnyJm5fVW5JEPpme+lIXmGZUYJQGYUTQ6yZ6pMFRnvvbqN7Y
        4hzrwFbkbuvGypvqM1p+PpRWv8mpCEJDzOoSbF43YM7G0yPcBp+jEeQj/agQZfwNQfcSh3
        Dayr7CXlcBpAwIB01GmA0vkOpLWkgtk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-A24Qu_cYOhK9EghHxGAOQQ-1; Mon, 18 Oct 2021 18:12:43 -0400
X-MC-Unique: A24Qu_cYOhK9EghHxGAOQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66FD110A8E00;
        Mon, 18 Oct 2021 22:12:42 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4907A5D6D5;
        Mon, 18 Oct 2021 22:12:33 +0000 (UTC)
Message-ID: <201eede7763cc364ca9c24b6b5810624e7db9de1.camel@redhat.com>
Subject: Re: TCP/IP connections sometimes stop retransmitting packets (in
 nested virtualization case)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>
Date:   Tue, 19 Oct 2021 01:12:32 +0300
In-Reply-To: <20211018164839-mutt-send-email-mst@kernel.org>
References: <1054a24529be44e11d65e61d8760f7c59dfa073b.camel@redhat.com>
         <ed357c14-a795-3116-4db9-8486e4f71751@gmail.com>
         <20211018164839-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-10-18 at 16:49 -0400, Michael S. Tsirkin wrote:
> On Mon, Oct 18, 2021 at 11:05:23AM -0700, Eric Dumazet wrote:
> > 
> > On 10/17/21 3:50 AM, Maxim Levitsky wrote:
> > > Hi!
> > >  
> > > This is a follow up mail to my mail about NFS client deadlock I was trying to debug last week:
> > > https://lore.kernel.org/all/e10b46b04fe4427fa50901dda71fb5f5a26af33e.camel@redhat.com/T/#u
> > >  
> > > I strongly believe now that this is not related to NFS, but rather to some issue in networking stack and maybe
> > > to somewhat non standard .config I was using for the kernels which has many advanced networking options disabled
> > > (to cut on compile time).
> > > This is why I choose to start a new thread about it.
> > >  
> > > Regarding the custom .config file, in particular I disabled CONFIG_NET_SCHED and CONFIG_TCP_CONG_ADVANCED. 
> > > Both host and the fedora32 VM run the same kernel with those options disabled.
> > > 
> > > 
> > > My setup is a VM (fedora32) which runs Win10 HyperV VM inside, nested, which in turn runs a fedora32 VM
> > > (but I was able to reproduce it with ordinary HyperV disabled VM running in the same fedora 32 VM)
> > >  
> > > The host is running a NFS server, and the fedora32 VM runs a NFS client which is used to read/write to a qcow2 file
> > > which contains the disk of the nested Win10 VM. The L3 VM which windows VM optionally
> > > runs, is contained in the same qcow2 file.
> > > 
> > > 
> > > I managed to capture (using wireshark) packets around the failure in both L0 and L1.
> > > The trace shows fair number of lost packets, a bit more than I would expect from communication that is running on the same host, 
> > > but they are retransmitted and don't cause any issues until the moment of failure.
> > > 
> > > 
> > > The failure happens when one packet which is sent from host to the guest,
> > > is not received by the guest (as evident by the L1 trace, and by the following SACKS from the guest which exclude this packet), 
> > > and then the host (on which the NFS server runs) never attempts to re-transmit it.
> > > 
> > > 
> > > The host keeps on sending further TCP packets with replies to previous RPC calls it received from the fedora32 VM,
> > > with an increasing sequence number, as evident from both traces, and the fedora32 VM keeps on SACK'ing those received packets, 
> > > patiently waiting for the retransmission.
> > >  
> > > After around 12 minutes (!), the host RSTs the connection.
> > > 
> > > It is worth mentioning that while all of this is happening, the fedora32 VM can become hung if one attempts to access the files 
> > > on the NFS share because effectively all NFS communication is blocked on TCP level.
> > > 
> > > I attached an extract from the two traces  (in L0 and L1) around the failure up to the RST packet.
> > > 
> > > In this trace the second packet with TCP sequence number 1736557331 (first one was empty without data) is not received by the guest
> > > and then never retransmitted by the host.
> > > 
> > > Also worth noting that to ease on storage I captured only 512 bytes of each packet, but wireshark
> > > notes how many bytes were in the actual packet.
> > >  
> > > Best regards,
> > > 	Maxim Levitsky
> > 
> > TCP has special logic not attempting a retransmit if it senses the prior
> > packet has not been consumed yet.
> > 
> > Usually, the consume part is done from NIC drivers at TC completion time,
> > when NIC signals packet has been sent to the wire.
> > 
> > It seems one skb is essentially leaked somewhere, and leaked (not freed)
> 
> Thanks Eric!
> 
> Maxim since the packets that leak are transmitted on the host,
> the question then is what kind of device do you use on the host
> to talk to the guest? tap?
> 
> 
Yes, tap with bridge, similiar to how libvirt does 'bridge' networking for vms.
I use my own set of scripts to run qemu directly.

Usually vhost is used in both L0 and L1, and it 'seems' to help to reproduce it,
but I did reproduced this with vhost disabled on both L0 and L1.

The capture was done on the bridge interface on L0, and on a virtual network card in L1.

It does seem that I am unable to make it fail again (maybe luck?) with CONFIG_NET_SCHED (and its suboptions)
and CONFIG_TCP_CONG_ADVANCED set back to defaults (everything 'm')

Also just to avoid going on the wrong path, note that I did once reproduce this on e1000e virtual nic,
thus virtio is likely not to blame here.


Thanks,
Best regards,
	Maxim Levitsky

