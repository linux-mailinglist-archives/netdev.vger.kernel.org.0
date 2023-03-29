Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2555A6CEC7C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjC2PNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjC2PN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:13:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DCB1BC1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680102760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zwm18/8QgowiaZ/AazlUy/nM7adyHlrf0JmZoTfhvu8=;
        b=WNyAivF4xOdMIAoDVyonSFZaIJrU4feu1/MNvpgtxcpBXt0cACkYdOntXlpyox88s3IaUy
        f12A1JGFl3d2C7m7PtHE52uYpx7ngy7zKiXCWFMQKfbsGkjeNTqgCcPlvj/h5XvR+umAHb
        dpa9930ymMoHkfqlquRK1ePycVuG9FA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-SThC8DvqP8KzM_EcY-3hqQ-1; Wed, 29 Mar 2023 11:12:38 -0400
X-MC-Unique: SThC8DvqP8KzM_EcY-3hqQ-1
Received: by mail-ed1-f70.google.com with SMTP id i22-20020a05640242d600b004f5962985f4so23166149edc.12
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680102757;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zwm18/8QgowiaZ/AazlUy/nM7adyHlrf0JmZoTfhvu8=;
        b=McJV6E8+5Don+5PBYZnhafnTr9p4M0ufa2LdXMoik1ntfxrVR43d73f90SNrE9u0J9
         yfTlHirDNpTcbDl9ZrOEX9gcwzWPnAvhth0SKSpYU2csd2es811F3jdwwrcGa6Dn/k0W
         pW6LO12K95vWjWc/kSU6FFedCOaudL6FwYMf0a3uPf8HvLsTtDf2XzW0yTNwDuV9JR/8
         QqEfJkBpFKMnFQpskOg+tfv0X4OkntL09sLv9vPbp2TST2ilvQYSvVk6XjQv0yKu0/LA
         5mXO42vJCcJ7MAMiog/9Yd1QJdFPChdDQv3yX7sc+2NcDcaqic3/xvoJORANR6GmPZEy
         SNdA==
X-Gm-Message-State: AAQBX9e5hyEb26M5EQiKArThLiXyH2b03+9nD2IqQJLDuDpJ72d8a/sp
        J48kP+ZaqyEFJzQjdH3Q0AJVSqWSljx4+fzXM0O6a0g3Gyt+IRthACjX/JhUt7yeV7tyNgS1MIU
        FGY+BdDrYepvKxEKh
X-Received: by 2002:a17:906:da1b:b0:932:b790:932c with SMTP id fi27-20020a170906da1b00b00932b790932cmr19196878ejb.44.1680102757122;
        Wed, 29 Mar 2023 08:12:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350YftREbJPRd/X2+My8E4Qj/TpoZVqhItoIcHshJ17xUd/cUEkAfEozx1xrX2HJeznaW5ZU2zA==
X-Received: by 2002:a17:906:da1b:b0:932:b790:932c with SMTP id fi27-20020a170906da1b00b00932b790932cmr19196849ejb.44.1680102756885;
        Wed, 29 Mar 2023 08:12:36 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id c14-20020a509f8e000000b005003fd12eafsm16950214edf.63.2023.03.29.08.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 08:12:36 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <b6fcfa8b-c2b3-8a92-fb6e-0760d5f6f5ff@redhat.com>
Date:   Wed, 29 Mar 2023 17:12:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Saeed Mahameed <saeedm@nvidia.com>,
        netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [pull request][net-next 00/15] mlx5: Drop internal page cache
 implementation
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20230328205623.142075-1-saeed@kernel.org>
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/03/2023 22.56, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave, Hi Jakub,
> 
> This series from Dragos provides the patches that remove the mlx5
> internal page cache implementation and convert mlx5 RX buffers to
> completely rely on the standard page pool.

It is awesome to finally see this happen! :-)))

--Jesper

