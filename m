Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C8F6E096B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjDMIyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjDMIyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C08100
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681376007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/ayCgB4BHYU53MBuC5QPpg8jAmYuyUSUdqQ4gE9310=;
        b=KzXAIoD1JCci8OpQ3Ye/CBwJqw9DCfK5ew8uyx/t7Qj6ed8NSn0P+a44eqURROHX+IEu6i
        M0PeKgLFEA10YLSpLZSDwoaEKgpvtz+pXaYbMNMWPdTG78JcEZObQGAZgrTV78KNeo821V
        EW7214acpXvE7jwGdiFrOWNu1CJECCI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-YiT6tueQO4u14I3-V0WfPg-1; Thu, 13 Apr 2023 04:53:25 -0400
X-MC-Unique: YiT6tueQO4u14I3-V0WfPg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-74a904f38f3so94682985a.1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681376005; x=1683968005;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c/ayCgB4BHYU53MBuC5QPpg8jAmYuyUSUdqQ4gE9310=;
        b=eV/5AyVQxAzdIaLTkAb0Eue6O9OzDMiuIXJEsrdN6fxs1dURVGsIogPzMSIiSznwgH
         7xA1VKsReuSVSVn+woXTOsSjikfbA6WKYwTxw+m4nsnuPFIigs94XA1yF/eqkVRKgmCf
         ewRXudLRcBB0TutVcorJtXBWlvsxyivkRWA6e638hJF5wJSxgJW9nlo45rjeqOjl+n2/
         qvqAqbpBJn0eFqW84BkxfYLCcFOcat+iVs6ownjdmUeGG6h5cBOxINQxYv17zvNRWBUT
         2dNqjjwAbOX9R9DyzsZhkPzr80AfrPT70qc0PQjashMJNQDwyxHqSwdCxG5h7mWp2yVZ
         1rHA==
X-Gm-Message-State: AAQBX9fU+1cROjDASdQLOXZSw0hGmrGCKDckVcvry4p9s1l+F0nox9DS
        FNCeT5cHhu8WEvmcFT9UfV2vl+WERRppQAjLiTKxjthMWuVH8MFyckSD3LUGiHDLETrrM0N/N7d
        LBiGaYKyaF06RpQn2
X-Received: by 2002:a05:6214:529b:b0:5ef:4436:b96f with SMTP id kj27-20020a056214529b00b005ef4436b96fmr1909088qvb.5.1681376004938;
        Thu, 13 Apr 2023 01:53:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350bIf8zkZ3pMxXqMlJegZ1MjfzBxJ1bTiipmj3lFDsmkwp8f+S7BMxMGzVhmg+UPdwJAGffBQg==
X-Received: by 2002:a05:6214:529b:b0:5ef:4436:b96f with SMTP id kj27-20020a056214529b00b005ef4436b96fmr1909070qvb.5.1681376004697;
        Thu, 13 Apr 2023 01:53:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-183.dyn.eolo.it. [146.241.232.183])
        by smtp.gmail.com with ESMTPSA id lb6-20020a056214318600b005e16003edc9sm280517qvb.104.2023.04.13.01.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 01:53:24 -0700 (PDT)
Message-ID: <9a56509f598e4c65584ceb8b331b784d6ccdafda.camel@redhat.com>
Subject: Re: [net-next Patch v9 0/6] octeontx2-pf: HTB offload support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        andrew@lunn.ch, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        naveenm@marvell.com, edumazet@google.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com,
        corbet@lwn.net
Date:   Thu, 13 Apr 2023 10:53:20 +0200
In-Reply-To: <20230412182756.6b1d28c6@kernel.org>
References: <20230411090359.5134-1-hkelam@marvell.com>
         <20230412182756.6b1d28c6@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-12 at 18:27 -0700, Jakub Kicinski wrote:
> On Tue, 11 Apr 2023 14:33:53 +0530 Hariprasad Kelam wrote:
> > octeontx2 silicon and CN10K transmit interface consists of five
> > transmit levels starting from MDQ, TL4 to TL1. Once packets are
> > submitted to MDQ, hardware picks all active MDQs using strict
> > priority, and MDQs having the same priority level are chosen using
> > round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> > Each level contains an array of queues to support scheduling and
> > shaping.
>=20
>=20
> Looks like Jake's comments from v7 apply.

Just to be more verbose, the above means clarifying the commit message
for patch 4/6 and try factor into separate helpers some code of
function __otx2_qos_txschq_cfg() in patch 6/6.

Thanks,

Paolo

