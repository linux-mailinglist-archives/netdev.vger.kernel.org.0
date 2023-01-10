Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5342663E2C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjAJK2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbjAJK2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:28:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46341A38A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673346474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9KIby0sHbh660F6W00pOyfjQiD0YxkgesI7WCpTcF84=;
        b=EAL0Rq/UAEVualdmxWIfF+UqbDhyA3COr9Hu9J6aRZE5ZYe0fjeKwjKh6EwoYCtZ8hdylg
        xCeQMKA1gl3QIiS9r5l9KMTTZzjfX25tDjJ5bRotQ1ROJO4hWK3q949mKPdH2JRLE8QqE/
        P5n5dPp308vLWKq0hSIjQWL/1Qdovto=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-10-qlFSvmyePB6bvvhr9vx-6g-1; Tue, 10 Jan 2023 05:27:53 -0500
X-MC-Unique: qlFSvmyePB6bvvhr9vx-6g-1
Received: by mail-qk1-f197.google.com with SMTP id bq39-20020a05620a46a700b006ffd5db9fe9so8391498qkb.2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:27:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9KIby0sHbh660F6W00pOyfjQiD0YxkgesI7WCpTcF84=;
        b=CQ19c95hp87DFn5ra5HtonAwfFetsgp+6Nb6LDTFVnbAgbdJNkCzgH/49b4d/F14si
         5RkEipd7+LRyD5ZzrI491vnis7PhRqg7CVF4/lutKGNEHzeHoUO0LUl0WhucRYifEsEN
         aWDY4HTWHKXJI8wpiQT0I47R6kIwxsVmISBG2zhv0y+FCYZSMuJlHfDm3kZ6HyTyZaw1
         mNkW3M6w4BI6Q6sICkhsN34U6oyhHxlkzq7KxG4I5M4J54X+n+/kU7kjtJpCmmzEV6uC
         Jlm0RS9kzsajD/DfMqFvOftva16/OsqgfktmmN3o3s+VQ8/Y4YkmS3XzhFJuxjprLwXy
         oP2Q==
X-Gm-Message-State: AFqh2kqkbOHfU6LxnA+a0VOGeB3cbpwjRpQR9M79A42VZ507vS3KNXEI
        3f9ncGmd74eE0lx0y9Y214ogT40cnqHWMGY75rfrMxzvxeG3jS/F2IAhRNPomoSU/cpKmFReko0
        /NES+kVEYeN36gzQQ
X-Received: by 2002:ac8:546:0:b0:3a9:9218:e110 with SMTP id c6-20020ac80546000000b003a99218e110mr96438704qth.37.1673346472296;
        Tue, 10 Jan 2023 02:27:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtNbXuxMZfi5jwcdohKmvDBprOB9kZdOoqzZtAC3vlZswt2hulAE8XHX60Y529sh9eOWOGAVg==
X-Received: by 2002:ac8:546:0:b0:3a9:9218:e110 with SMTP id c6-20020ac80546000000b003a99218e110mr96438670qth.37.1673346472039;
        Tue, 10 Jan 2023 02:27:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id a19-20020ac81093000000b0039a610a04b1sm5804132qtj.37.2023.01.10.02.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:27:51 -0800 (PST)
Message-ID: <b87cdb13baab2a02be2fb3ffc54c581d097cbe7d.camel@redhat.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add aux timestamps fifo clearance
 wait
From:   Paolo Abeni <pabeni@redhat.com>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        stable@vger.kernel.org
Date:   Tue, 10 Jan 2023 11:27:47 +0100
In-Reply-To: <20230109151546.26247-1-noor.azura.ahmad.tarmizi@intel.com>
References: <20230109151546.26247-1-noor.azura.ahmad.tarmizi@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 23:15 +0800, Noor Azura Ahmad Tarmizi wrote:
> Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
> (ATSFC) to clear. This is to ensure no residue fifo value is being read
> erroneously.
> 
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

Please post a new revision of this patch including a suitable 'Fixes'
tag, thanks!

Paolo

