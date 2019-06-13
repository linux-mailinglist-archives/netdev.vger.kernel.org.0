Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1220D439F4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbfFMPRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:17:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732180AbfFMNUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:20:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 791F836883;
        Thu, 13 Jun 2019 13:20:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC8405C290;
        Thu, 13 Jun 2019 13:20:37 +0000 (UTC)
Message-ID: <b0c97579d77ef09f73ee940e27fae2a595402888.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net: sched: add mpls manipulation actions
 to TC
From:   Davide Caratti <dcaratti@redhat.com>
To:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
In-Reply-To: <1560343906-19426-2-git-send-email-john.hurley@netronome.com>
References: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
         <1560343906-19426-2-git-send-email-john.hurley@netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 13 Jun 2019 15:20:36 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 13 Jun 2019 13:20:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello John!

On Wed, 2019-06-12 at 13:51 +0100, John Hurley wrote:
> Currently, TC offers the ability to match on the MPLS fields of a packet
> through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> actions do not allow the modification or manipulation of such fields.
> 
> Add a new module that registers TC action ops to allow manipulation of
> MPLS. This includes the ability to push and pop headers as well as modify
> the contents of new or existing headers. A further action to decrement the
> TTL field of an MPLS header is also provided.
> 
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

[...]

> index a93680f..197621a 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -83,6 +83,7 @@ enum {
>  #define TCA_ACT_SIMP 22
>  #define TCA_ACT_IFE 25
>  #define TCA_ACT_SAMPLE 26
> +#define TCA_ACT_MPLS 27

like I mentioned in my reply to "[PATCH net-next 1/3] net/sched: Introduce
action ct", I think that 27 is forbidden on net-next: this number is
already used in the uAPI for TCA_ID_CTINFO (see below). Like suggested in
the comment above the definition of TCA_ACT_GACT, it's sufficient to add
TCA_ID_MPLS in the enum below.

>  /* Action type identifiers*/
>  enum tca_id {
> @@ -104,6 +105,7 @@ enum tca_id {
>  	TCA_ID_SIMP = TCA_ACT_SIMP,
>  	TCA_ID_IFE = TCA_ACT_IFE,
>  	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
> +	TCA_ID_MPLS = TCA_ACT_MPLS,
>  	/* other actions go here */
>  	TCA_ID_CTINFO,
>  	__TCA_ID_MAX = 255

and the line that adds TCA_ID_MPLS to enum tca_id should be placed right
before __TCA_ID_MAX, so that the uAPI is preserved (i.e. the value of
TCA_ID_CTINFO does not change).

thanks!
-- 
davide


