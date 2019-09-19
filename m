Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9A0B7ADB
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfISNv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388145AbfISNv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 09:51:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34A532101;
        Thu, 19 Sep 2019 13:51:59 +0000 (UTC)
Received: from ovpn-118-24.ams2.redhat.com (unknown [10.36.118.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2B495C1B5;
        Thu, 19 Sep 2019 13:51:57 +0000 (UTC)
Message-ID: <5fc20a137099363cb7b9c7af9ca6f30e31c1f836.camel@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
From:   Paolo Abeni <pabeni@redhat.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Date:   Thu, 19 Sep 2019 15:51:56 +0200
In-Reply-To: <CAJ3xEMjucmc-6k=kvEp99uZbCA50tUwPMK1z__wAG+ah7qNzsg@mail.gmail.com>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
         <CAJ3xEMjucmc-6k=kvEp99uZbCA50tUwPMK1z__wAG+ah7qNzsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 19 Sep 2019 13:51:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-19 at 15:37 +0300, Or Gerlitz wrote:
> On Wed, Sep 18, 2019 at 2:48 PM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> > This patchset adds support to do GRO/GSO by chaining packets
> > of the same flow at the SKB frag_list pointer. This avoids
> > the overhead to merge payloads into one big packet, and
> > on the other end, if GSO is needed it avoids the overhead
> > of splitting the big packet back to the native form.
> > 
> > Patch 1 Enables UDP GRO by default.
> > 
> > Patch 2 adds a netdev feature flag to enable listifyed GRO,
> > this implements one of the configuration options discussed
> > at netconf 2019.
> [..]
> 
> The slide say that linked packets travel together though the stack.
> 
> This sounds somehow similar to the approach suggested by Ed
> for skb lists. I wonder what we can say on cases where each of the
> approaches would function better.

The 'listification' by Ed Cree can potentially aggregate across
multiple flows, so it can trigger when UDP GRO can not.

On the other side, fraglist performance impact is more limited, because
we still have to walk the list on each step. UDP GRO will improve
performances considerably more, if it can be triggered - e.g. all pkts
belong to the same flow.

Cheers,

Paolo

