Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154F6512C41
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiD1HJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244792AbiD1HJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:09:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DFCC19C36
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651129564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RX0IluUFjyFGJB9XgIGY/YNKpJD21MjW7iyGoQ/bciQ=;
        b=MgCRQOR0bXRwCG/n9wB3V/1V5KF7AWuuzIMVPknPI4vVCSoQUbZH5PD17M/bicFwyCK9zd
        U/c+O6emWUPdgwPJC0U7hmZdBHcKzCzJPpiiZKIqxmIpg0F+bxXZzlHF14bswCE95j41Bt
        KWQsumSgUPpfKbM7Lxgo1yrCyjPR6xo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-c8IPXo1ANpG3ysPI_LdoLA-1; Thu, 28 Apr 2022 03:06:03 -0400
X-MC-Unique: c8IPXo1ANpG3ysPI_LdoLA-1
Received: by mail-qt1-f199.google.com with SMTP id cf23-20020a05622a401700b002f35b28fd73so2735044qtb.12
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 00:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RX0IluUFjyFGJB9XgIGY/YNKpJD21MjW7iyGoQ/bciQ=;
        b=2vO4o0ztg+2yA2xjVFdaNXUWICQtZ/AJwCX3pYnmhTPA+1sSEVHgIbwcwsbLj8pc7H
         nAwqwALzItQpg/lehr45j1pQ5z4FM1oL+WCuuVTOkQjGZIgT/kAVP+xl0SIEfsJ5o+18
         /rXFe07kziaBkSgkbQOh1hMh10H8IbWziWd/VuTmHWH8qnnzCVCn7gVtTW0QVdjcdeTu
         9dGILWVrswjC4YCmg1qSqTc1cH9quwIMrxnf3+63Rb/dlsernxDdBnwVUy4zUOQROHtV
         ylso6kbLmYtBCi/xYjQb8P4sQEEgBjtYjHlkD05edNVSeHaOn3kbB+7nJKjdW1Oo8+5R
         0J6Q==
X-Gm-Message-State: AOAM532KmdoJNRd2aD6tAUTdQr3d4+LAvMSIXgM4JQ+ZpZxKPIDQi4cX
        Ix31aW9cXqLoCQZJ5XWB/S8sRgWA6XqeoXZlyoLqMR1BkkwiG2PYUDbGK2EfQon7NLfL+M46t0P
        X5/vqlLex/GWNVBuD
X-Received: by 2002:ac8:5fcb:0:b0:2f3:4799:1649 with SMTP id k11-20020ac85fcb000000b002f347991649mr22339574qta.522.1651129562776;
        Thu, 28 Apr 2022 00:06:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU2oeLrstNHTLoVNiOiYqy8PCp5qFcyD0PvqMZ6dBrsfSJtI6yAgZINx2lBg+bbQaYrXCEkQ==
X-Received: by 2002:ac8:5fcb:0:b0:2f3:4799:1649 with SMTP id k11-20020ac85fcb000000b002f347991649mr22339552qta.522.1651129562541;
        Thu, 28 Apr 2022 00:06:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-117-160.dyn.eolo.it. [146.241.117.160])
        by smtp.gmail.com with ESMTPSA id p13-20020a05622a048d00b002e1ce0c627csm11706888qtx.58.2022.04.28.00.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 00:06:02 -0700 (PDT)
Message-ID: <530adc71b52e774c92c53d235701710dbc9866a9.camel@redhat.com>
Subject: Re: [PATCH net 1/1] net: stmmac: disable Split Header (SPH) for
 Intel platforms
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Ong@vger.kernel.org, Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Date:   Thu, 28 Apr 2022 09:05:57 +0200
In-Reply-To: <20220428015538.GC26326@linux.intel.com>
References: <20220426074531.4115683-1-tee.min.tan@linux.intel.com>
         <8735i0ndy7.fsf@kurt> <20220428015538.GC26326@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-04-28 at 09:55 +0800, Tan Tee Min wrote:
> On Tue, Apr 26, 2022 at 03:58:56PM +0200, Kurt Kanzenbach wrote:
> > Hi,
> > 
> > On Tue Apr 26 2022, Tan Tee Min wrote:
> > > Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
> > > of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
> > > This SPH limitation will cause ping failure when the packets size exceed
> > > the MTU size. For example, the issue happens once the basic ping packet
> > > size is larger than the configured MTU size and the data is lost inside
> > > the fragmented packet, replaced by zeros/corrupted values, and leads to
> > > ping fail.
> > > 
> > > So, disable the Split Header for Intel platforms.
> > 
> > Does this issue only apply on Intel platforms?
> 
> According to Synopsys IP support, they have confirmed the header-payload
> splitting for IPv4 fragmented packets is not supported for the Synopsys
> Ether IPs.
> 
> Intel platforms are integrating with GMAC EQoS IP which is impacted by the
> limitation above, so we are changing the default SPH setting to disabled
> for Intel Platforms only.
> 
> If anyone can confirm on their platform also having the same issues,
> then we would change the SPH default to disable across the IPs.

Could you please provide a Fixes tag here? 

Thanks!

Paolo

