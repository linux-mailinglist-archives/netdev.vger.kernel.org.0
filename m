Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33E257E01B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiGVKhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiGVKhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:37:05 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5473ABA24F
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 03:37:04 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id l11so7275551ybu.13
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 03:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZXV7spB5ZWU5K7GWsoui8Bphj1cNvVhFn/ZvvmSing=;
        b=bVZoDU6yBgk2+vNGfNBqfVrY4Bt1R0qn5OyV3iEBHCHKM9yV1nsjKOa6DshjGTpWir
         r0Ve6AdugLmQv7oSS+5GBtIu7jhfGf7rwimSzVlmU+T0DfQgbrVCouQaIZHzVsI+AJQd
         fF41sKp0flVbUagS9SPWMWkT+Efll2TNkgn0UbJSnBrTuAJWp0HvbF4TsEVRGjnTaaRc
         2jhcvyMJq1pW3gE8D4GuOPmMtc1KR9jYCb3MSO7SJSi8qk+IMUE4t7y/b4d+w52tG8F0
         rDkrtkDxXZevCbb28YX3MUV8qrhioOrEU6kOX83xQn+RtkYLJqbJEeOdKDbjPdOPNC2Q
         iLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZXV7spB5ZWU5K7GWsoui8Bphj1cNvVhFn/ZvvmSing=;
        b=aG4D9d7xnTr5+l7jQkx7XyT6Nbi+sxuTSDZp+dnmTDJhLeK2t40+BkcqF/Q5k3vvf3
         q9wNzAHhzOSlfDS5QD8IK5qCP06WM8T7Owd1JtIEeJlkTn2zS+APDkivtk1s5p4owjAD
         n+qQYVQhZfz2GK3V3ETGSO80DhYci78tpdE9DV/OazryEoTMg0dkrunroEm2RC/e/wyg
         EZW15tsQPuNVfiweo+inadUwS3Nf1eDwJLMC48umfg4ImBoOV6g6DXKsOSuglzCrmqKg
         yGVZeB3KnEB2nrgJ21gQA/N4QdRC5l1dbNFBTOunc5MwqSkcinGczI2dAWYI8+RI/J4l
         zkAw==
X-Gm-Message-State: AJIora+rk8XMINs4RzlkqEs5hxN9F+WoEowSylamR680mJipvskFcafm
        NUgN2pyXS09gjnrciqgNXIDYUwTphO7ie+J7nqBkqA==
X-Google-Smtp-Source: AGRyM1vI4WMTZ8dacZeoMfIM3u0pw8gDKN3iU57tDYVl+x+hIJBD3hOWhpnGx4itgOaWoNFF3b5dHfVnP53BG5K8awI=
X-Received: by 2002:a25:b0c:0:b0:670:a7c6:5c15 with SMTP id
 12-20020a250b0c000000b00670a7c65c15mr2138060ybl.387.1658486223328; Fri, 22
 Jul 2022 03:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220722182248.1.I20e96c839200bb75cd6af80384f16c8c01498f57@changeid>
In-Reply-To: <20220722182248.1.I20e96c839200bb75cd6af80384f16c8c01498f57@changeid>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jul 2022 12:36:51 +0200
Message-ID: <CANn89iJehOVme9-3qnHTdhnoKUP36AW=3A232aqBuzLDHDCGxw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hci_sync: Use safe loop when adding accept list
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Zhengping Jiang <jiangzp@google.com>,
        Michael Sun <michaelfsun@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 12:23 PM Archie Pusaka <apusaka@google.com> wrote:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> When in the middle of adding accept list, the userspace can still
> remove devices, therefore causing crash if the removed device is
> the one being processed.
>
> Use a safe loop mechanism to guard against deletion while iterating
> the pending items.

 "the userspace can still remove devices" is a bit vague.

It seems that the issue at hand is that hci_le_add_accept_list_sync() can
move the current item from  pend_le_conns / pend_le_reports lists ?

Hopefully these lists can not be changed by other threads while
hci_update_accept_list_sync() is running ?


>
> Below is a sample btsnoop log when user enters wrong passkey when
> pairing a LE keyboard and the corresponding stacktrace.
> @ MGMT Event: Command Complete (0x0001) plen 10
>       Add Device (0x0033) plen 7
>         Status: Success (0x00)
>         LE Address: CA:CA:BD:78:37:F9 (Static)
> < HCI Command: LE Add Device To Accept List (0x08|0x0011) plen 7
>         Address type: Random (0x01)
>         Address: CA:CA:BD:78:37:F9 (Static)
> @ MGMT Event: Device Removed (0x001b) plen 7
>         LE Address: CA:CA:BD:78:37:F9 (Static)
> > HCI Event: Command Complete (0x0e) plen 4
>       LE Add Device To Accept List (0x08|0x0011) ncmd 1
>         Status: Success (0x00)
>
> [  167.409813] Call trace:
> [  167.409983]  hci_le_add_accept_list_sync+0x64/0x26c
> [  167.410150]  hci_update_passive_scan_sync+0x5f0/0x6dc
> [  167.410318]  add_device_sync+0x18/0x24
> [  167.410486]  hci_cmd_sync_work+0xe8/0x150
> [  167.410509]  process_one_work+0x140/0x4d0
> [  167.410526]  worker_thread+0x134/0x2e4
> [  167.410544]  kthread+0x148/0x160
> [  167.410562]  ret_from_fork+0x10/0x30
>
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>

Please add a Fixes: tag

> Reviewed-by: Zhengping Jiang <jiangzp@google.com>
> Reviewed-by: Michael Sun <michaelfsun@google.com>
>
> ---
>
>  net/bluetooth/hci_sync.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 3067d94e7a8e..8e843d34f7de 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -1863,7 +1863,7 @@ struct sk_buff *hci_read_local_oob_data_sync(struct hci_dev *hdev,
>   */
>  static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
>  {
> -       struct hci_conn_params *params;
> +       struct hci_conn_params *params, *tmp;
>         struct bdaddr_list *b, *t;
>         u8 num_entries = 0;
>         bool pend_conn, pend_report;
> @@ -1930,7 +1930,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
>          * just abort and return filer policy value to not use the
>          * accept list.
>          */
> -       list_for_each_entry(params, &hdev->pend_le_conns, action) {
> +       list_for_each_entry_safe(params, tmp, &hdev->pend_le_conns, action) {
>                 err = hci_le_add_accept_list_sync(hdev, params, &num_entries);
>                 if (err)
>                         goto done;
> @@ -1940,7 +1940,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
>          * the list of pending reports and also add these to the
>          * accept list if there is still space. Abort if space runs out.
>          */
> -       list_for_each_entry(params, &hdev->pend_le_reports, action) {
> +       list_for_each_entry_safe(params, tmp, &hdev->pend_le_reports, action) {
>                 err = hci_le_add_accept_list_sync(hdev, params, &num_entries);
>                 if (err)
>                         goto done;
> --
> 2.37.1.359.gd136c6c3e2-goog
>
