Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4991A2D34F2
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgLHVJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 16:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgLHVJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 16:09:27 -0500
Date:   Tue, 8 Dec 2020 10:42:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607452944;
        bh=nY7PYCioAPpxqdRM9+J5Fipi94C2gwsu6XanIKPCqVc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PE/oryX7HwFJx+RjzoAC+WKYBsVdvl7Va8ITfMMJ0oK+p70/YkDApmIfCw5bPMzre
         oem4djKzUKzH82hsKXYneLHCLrsOeoXIwK/j6JzKBE1axqDQOIxq0j8Qfk7MztXBLx
         423OPAbOe0u/qnGcPDQgpvLJN9b6pselUBdssPltLU/LG0ZwivACYI9p6uUUbjh+YL
         pqQN4CNKauFPaSKGawFnKdFzDWJ9xn9Cmza+grsEsIn3XVZJNutglnBbddI2fDFHS+
         5S/EX3VN/c7Qcb7ZNJod8ahO1fp0BHc1lHR+2HBwhyx5DV8FbQb78Zo9goqg9Hbzta
         6JsziLPMe/EfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Duncan <davdunc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexander Graf <graf@amazon.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH net-next v2 1/4] vm_sockets: Include flags field in the
 vsock address data structure
Message-ID: <20201208104222.605bb669@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <73ff948f-f455-7205-bfaa-5b468b2528c2@amazon.com>
References: <20201204170235.84387-1-andraprs@amazon.com>
        <20201204170235.84387-2-andraprs@amazon.com>
        <20201207132908.130a5f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <73ff948f-f455-7205-bfaa-5b468b2528c2@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 20:23:24 +0200 Paraschiv, Andra-Irina wrote:
> >> --- a/include/uapi/linux/vm_sockets.h
> >> +++ b/include/uapi/linux/vm_sockets.h
> >> @@ -145,7 +145,7 @@
> >>
> >>   struct sockaddr_vm {
> >>        __kernel_sa_family_t svm_family;
> >> -     unsigned short svm_reserved1;
> >> +     unsigned short svm_flags;
> >>        unsigned int svm_port;
> >>        unsigned int svm_cid;
> >>        unsigned char svm_zero[sizeof(struct sockaddr) -  
> > Since this is a uAPI header I gotta ask - are you 100% sure that it's
> > okay to rename this field?
> >
> > I didn't grasp from just reading the patches whether this is a uAPI or
> > just internal kernel flag, seems like the former from the reading of
> > the comment in patch 2. In which case what guarantees that existing
> > users don't pass in garbage since the kernel doesn't check it was 0?  
> 
> That's always good to double-check the uapi changes don't break / assume 
> something, thanks for bringing this up. :)
> 
> Sure, let's go through the possible options step by step. Let me know if 
> I get anything wrong and if I can help with clarifications.
> 
> There is the "svm_reserved1" field that is not used in the kernel 
> codebase. It is set to 0 on the receive (listen) path as part of the 
> vsock address initialization [1][2]. The "svm_family" and "svm_zero" 
> fields are checked as part of the address validation [3].
> 
> Now, with the current change to "svm_flags", the flow is the following:
> 
> * On the receive (listen) path, the remote address structure is 
> initialized as part of the vsock address init logic [2]. Then patch 3/4 
> of this series sets the "VMADDR_FLAG_TO_HOST" flag given a set of 
> conditions (local and remote CID > VMADDR_CID_HOST).
> 
> * On the connect path, the userspace logic can set the "svm_flags" 
> field. It can be set to 0 or 1 (VMADDR_FLAG_TO_HOST); or any other value 
> greater than 1. If the "VMADDR_FLAG_TO_HOST" flag is set, all the vsock 
> packets are then forwarded to the host.
> 
> * When the vsock transport is assigned, the "svm_flags" field is 
> checked, and if it has the "VMADDR_FLAG_TO_HOST" flag set, it goes on 
> with a guest->host transport (patch 4/4 of this series). Otherwise, 
> other specific flag value is not currently used.
> 
> Given all these points, the question remains what happens if the 
> "svm_flags" field is set on the connect path to a value higher than 1 
> (maybe a bogus one, not intended so). And it includes the 
> "VMADDR_FLAG_TO_HOST" value (the single flag set and specifically used 
> for now, but we should also account for any further possible flags). In 
> this case, all the vsock packets would be forwarded to the host and 
> maybe not intended so, having a bogus value for the flags field. Is this 
> possible case what you are referring to?

Correct. What if user basically declared the structure on the stack,
and only initialized the fields the kernel used to check?

This problem needs to be at the very least discussed in the commit
message.
