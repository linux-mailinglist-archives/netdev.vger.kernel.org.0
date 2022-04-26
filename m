Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36483510C14
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355865AbiDZWh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355856AbiDZWh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:37:27 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE013565E
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:34:16 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id z2so197473oic.6
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QOVruyTRY05/IB4dGodf9j5s8WkZhLYEMF1zPjhJnqU=;
        b=FJgqu7tUhGTf4pp2slwvkEMS7a5eJjGcvKCLSIztNY+14AkXepqJ0SqpdNBcZky/WX
         Fb90MZZxHTxzXlynFw3KyoxfOqTufkEYeGoGRNzqOyKWVxYAUerSB1pA3QZMrJsotXdQ
         YjIu5S4xHw9lauMzCV2DA+LrVZzjomjl/ywhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QOVruyTRY05/IB4dGodf9j5s8WkZhLYEMF1zPjhJnqU=;
        b=Bc/nEiigNH5V48KrU3iDD7YWAByaPj/ae1uBUvD8X3E3fqcY+KVygu4Wzs4Vl0Q6WN
         xFvpqGT+M9uK9p/gjzqq+S3mYJQq5AZg3SVKEgUc6kg7JXKDpe9uOkFazUtLBwlsK7y8
         5w01JoY0tP4jMZcur9rFcZEnJRBnPeNQUiH0HopRLon7m8VBBxru5+k763rCJrApfSWF
         v1QJtwLQw7dBuSEOhSLe98GtiKdKBOJEDW0A7LVA4Skge7aaSCPo1tmzpyU+F4uUDtqW
         gSwSFivy0I3ylaLRpjQd6hnMfVqUaucB/QGsSsxjKeRwlfIXdv504SHEc2FUXzWui+B2
         P+LA==
X-Gm-Message-State: AOAM53241Ixui178uzROKMMApmngsQcOJHq+OARVz/oc/+7IEW9NnlDs
        MSKnz89jA4CFs5SFtF4EmCPIfGk0N4Cyug==
X-Google-Smtp-Source: ABdhPJyXS0DZQ5NI0MbLzFDB7blpacVmIgf/B/JBzijerqZaiqHFhqPyn8eTHYcDIc1r0xFkWWS6/w==
X-Received: by 2002:a05:6808:2386:b0:322:c9bb:4994 with SMTP id bp6-20020a056808238600b00322c9bb4994mr11568928oib.49.1651012455890;
        Tue, 26 Apr 2022 15:34:15 -0700 (PDT)
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com. [209.85.160.50])
        by smtp.gmail.com with ESMTPSA id m5-20020a056808024500b003222ff73171sm5306339oie.17.2022.04.26.15.34.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 15:34:13 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-e5e433d66dso166855fac.5
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:34:13 -0700 (PDT)
X-Received: by 2002:a05:6870:4201:b0:e6:47c4:e104 with SMTP id
 u1-20020a056870420100b000e647c4e104mr14046899oac.257.1651012453086; Tue, 26
 Apr 2022 15:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
In-Reply-To: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 26 Apr 2022 15:34:02 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPNFwvYVBMHjbTNQ-uTnQrs5TvPAH2jXgPKuFLUw2GbZA@mail.gmail.com>
Message-ID: <CA+ASDXPNFwvYVBMHjbTNQ-uTnQrs5TvPAH2jXgPKuFLUw2GbZA@mail.gmail.com>
Subject: Re: [PATCH v2] ath10k: skip ath10k_halt during suspend for driver
 state RESTARTING
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     kvalo@kernel.org, quic_wgong@quicinc.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 3:20 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
>
> Double free crash is observed when FW recovery(caused by wmi
> timeout/crash) is followed by immediate suspend event. The FW recovery
> is triggered by ath10k_core_restart() which calls driver clean up via
> ath10k_halt(). When the suspend event occurs between the FW recovery,
> the restart worker thread is put into frozen state until suspend completes.
> The suspend event triggers ath10k_stop() which again triggers ath10k_halt()
> The double invocation of ath10k_halt() causes ath10k_htt_rx_free() to be
> called twice(Note: ath10k_htt_rx_alloc was not called by restart worker
> thread because of its frozen state), causing the crash.
...
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> Co-developed-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
> Changes in v2:
> - Fixed typo, replaced ath11k by ath10k in the comments.
> - Adjusted the position of my S-O-B tag.
> - Added the Tested-on tag.

You could have retained my:

Reviewed-by: Brian Norris <briannorris@chromium.org>

but no worries; it's just a few characters ;)
