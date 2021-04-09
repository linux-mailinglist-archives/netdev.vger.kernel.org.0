Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9722135A4FE
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDIR4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:56:35 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:33511 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233332AbhDIR4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 13:56:34 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 139Htp74014136;
        Fri, 9 Apr 2021 19:55:57 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id A5D921200A8;
        Fri,  9 Apr 2021 19:55:46 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1617990947; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pni0KvBbEd9KTaOWkuAW37WojjxsQ6NNGlUAutGZc7c=;
        b=M9P7KmqNMt1w5lUBFckAsIZkfaw1R//JwL01Pn4CZ9d2516zOPULHUUPPxsZREVx8Fhpo4
        LQoF1OYMSp0madDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1617990947; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pni0KvBbEd9KTaOWkuAW37WojjxsQ6NNGlUAutGZc7c=;
        b=FQJrs19RAr+0OSkd71Wqabf8tQmFALZZw7KuuQNayEem2TNWZ72ae/HyDvLLPmi7xR+bg4
        f/7Z3OVsmkBwWSZ1xMIslhPx8RwCJcVdFKDVY87etuUkiDWv0JFjxK0mr7ODajWCm/bQW+
        j8JdMNVZI8oKLN8qFR9tf835JAXUqV6wkMB3F7wdxItJWcLoUrPTbxzdhSZpKKZUmHVxbd
        qPMSuYrsfP7P5qQqg2Uxf+tTpT+zIJGjft2YiOD4GuLd0QAAzqmSdF2bQjRaKxtnb0pcl2
        UkMDUiZ/Tn7hp7xH8uURXYjVTVhmD9WQii9PbTgSSLcxg5KWjMTst56O5IdzkQ==
Date:   Fri, 9 Apr 2021 19:55:46 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC net-next 1/1] seg6: add counters support for SRv6
 Behaviors
Message-Id: <20210409195546.d528ca172b7360c9ac4d1dd3@uniroma2.it>
In-Reply-To: <26222d31-2a27-c250-97e2-9220c098d836@gmail.com>
References: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
        <20210407180332.29775-2-andrea.mayer@uniroma2.it>
        <26222d31-2a27-c250-97e2-9220c098d836@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 16:55:41 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 4/7/21 12:03 PM, Andrea Mayer wrote:
> > diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> > index 3b39ef1dbb46..ae5e3fd12b73 100644
> > --- a/include/uapi/linux/seg6_local.h
> > +++ b/include/uapi/linux/seg6_local.h
> > @@ -27,6 +27,7 @@ enum {
> >  	SEG6_LOCAL_OIF,
> >  	SEG6_LOCAL_BPF,
> >  	SEG6_LOCAL_VRFTABLE,
> > +	SEG6_LOCAL_COUNTERS,
> >  	__SEG6_LOCAL_MAX,
> >  };
> >  #define SEG6_LOCAL_MAX (__SEG6_LOCAL_MAX - 1)
> > @@ -78,4 +79,11 @@ enum {
> >  
> >  #define SEG6_LOCAL_BPF_PROG_MAX (__SEG6_LOCAL_BPF_PROG_MAX - 1)
> >  
> > +/* SRv6 Behavior counters */
> > +struct seg6_local_counters {
> > +	__u64 rx_packets;
> > +	__u64 rx_bytes;
> > +	__u64 rx_errors;
> > +};
> > +
> >  #endif
> 
> It's highly likely that more stats would get added over time. It would
> be good to document that here for interested parties and then make sure
> iproute2 can handle different sized stats structs. e.g., commit support
> to your repo, then add a new one (e.g, rx_drops) and verify the
> combinations handle it. e.g., old kernel - new iproute2, new kernel -
> old iproute, old - old and new-new.
> 

Hi David,
thanks for your review.

I totally agree with you: we may want to add other counters in the future, even
if they are not considered in RFC8986.

With that in mind, the shared struct seg6_local_counters is not the best way to
go if we want to add other counters (because it will be difficult to manage
different sized structures when considering different kernel/iproute2 versions).

To make it easier adding new counters, instead of sharing the struct
seg6_local_counters, I would use netlink nested attributes to exchange counters
individually. In this way, only recognized (nested) attributes can be processed
by both the kernel and iproute2.

For example:

enum {
       SEG6_LOCAL_CNT_UNSPEC,
       SEG6_LOCAL_CNT_PAD,             /* padding for 64 bits values */
       SEG6_LOCAL_CNT_RX_PACKETS,
       SEG6_LOCAL_CNT_RX_BYTES,
       SEG6_LOCAL_CNT_RX_ERRORS,
       __SEG6_LOCAL_CNT_MAX,
};
#define SEG6_LOCAL_CNT_MAX (__SEG6_LOCAL_CNT_MAX - 1)

updating the policy for SEG6_LOCAL_COUNTERS to NLA_NESTED.

Then, I create a new policy for counters which handles each supported
counter separately.

static const struct
nla_policy seg6_local_counters_policy[SEG6_LOCAL_CNT_MAX + 1] = {
       [SEG6_LOCAL_CNT_RX_PACKETS]     = { .type = NLA_U64 },
       [SEG6_LOCAL_CNT_RX_BYTES]       = { .type = NLA_U64 },
       [SEG6_LOCAL_CNT_RX_ERRORS]      = { .type = NLA_U64 },
};

At the end, I update the parse_nla_counters(), put_nla_counters(), etc
according to the changes, i.e:
 - nla_parse_nested() in parse_nla_counters();
 - nla_nest_{start/end}() and for each supported counter nla_put_u64_64bit()
   in put_nla_counters().

On the iproute2 side, we have to update the code to reflect the changes
discussed above. 

I plan to issue an RFC v2 in a few days.

Andrea
