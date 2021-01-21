Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D583D2FEC79
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbhAUNkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:40:19 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:34900 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbhAUNh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:37:57 -0500
Received: by mail-pf1-f170.google.com with SMTP id w14so1516014pfi.2;
        Thu, 21 Jan 2021 05:37:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=UUiCXFOSqjAdUvC0wdNT72TPUZ0us785diWKGNau67U=;
        b=adl9o12y/CgGMozjQrScnzyDArrOBpch+XzKVCE5zuSJ4ox39Kw7mp6ozBLrYG28+c
         i36ubnze3YsUclaEEloh7yqjTMvAaWrg8qu9I34KaLaBYfJ1YaNocm31W0UaTTQGaYhx
         Pfj5HRiLKDVMPm/IpZhaFJpEJx+1zDCrJsyE2nGB9BI3KZmsJCxSPKH7+YN/fKc08Xzs
         8IYekaofdrbvcK4vyJ8eutmQqEnNALh4MwVvD/7dNnBY2kfrRa0/1Wr+WNVFbcCubyfM
         qQ0ZjFLC23Kcw0OicuHjSMhE5Olam6U/pD92c6fTSMQLpp8QNBtaR1cdQMdhSclgdjUd
         nZWw==
X-Gm-Message-State: AOAM530qt/ZqpEQkNeQGqI5u1R7hrpFL8CQ7u+kYOSW6clWuVG/COmjM
        y20HpXOpioZTKSIepnmun0Y=
X-Google-Smtp-Source: ABdhPJwJtZ3kQCTWB3UcwNNL4F5Dgg+OSEw3EyBIYjfB6PBauVbsf8bu80Dphfic1UGjQfQipMeypw==
X-Received: by 2002:a63:f109:: with SMTP id f9mr14587480pgi.390.1611236216077;
        Thu, 21 Jan 2021 05:36:56 -0800 (PST)
Received: from [10.101.46.154] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id w186sm1795614pfc.182.2021.01.21.05.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 05:36:54 -0800 (PST)
To:     Luca Coelho <luciano.coelho@intel.com>,
        Ihab Zhaika <ihab.zhaika@intel.com>
From:   You-Sheng Yang <vicamo.yang@canonical.com>
Subject: iwlwifi may wrongly cast a iwl_cfg_trans_params to iwl_cfg
Cc:     "David S. Miller\"" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        You-Sheng Yang <vicamo@gmail.com>
Message-ID: <c651c75d-e1f4-ac7b-aa8f-b0a2035cbf4f@canonical.com>
Date:   Thu, 21 Jan 2021 21:36:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

With an Intel AX201 Wi-Fi [8086:43f0] subsystem [1a56:1652] pcie card,
device fails to load firmware with following error messages:

  Intel(R) Wireless WiFi driver for Linux
  iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
  iwlwifi 0000:00:14.3: Direct firmware load for (efault)128.ucode
failed with error -2
  iwlwifi 0000:00:14.3: Direct firmware load for (efault)127.ucode
failed with error -2
  ...
  iwlwifi 0000:00:14.3: Direct firmware load for (efault)0.ucode failed
with error -2
  iwlwifi 0000:00:14.3: no suitable firmware found!
  iwlwifi 0000:00:14.3: minimum version required: (efault)0
  iwlwifi 0000:00:14.3: maximum version supported: (efault)128

This is also reported on some public forums:

*
https://askubuntu.com/questions/1297311/ubuntu-20-04-wireless-not-working-for-intel-ax1650i-lenovo-thinkpad
*
https://www.reddit.com/r/pop_os/comments/jxmnre/wifi_and_bluetooth_issues_in_2010/

In drivers/net/wireless/intel/iwlwifi/pcie/drv.c:

  static const struct pci_device_id iwl_hw_card_ids[] = {
    {IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)},
    ...
    {IWL_PCI_DEVICE(0x43F0, PCI_ANY_ID, iwl_qu_long_latency_trans_cfg)},
    ...
  };

The third argument to IWL_PCI_DEVICE macro will be assigned to
driver_data field of struct pci_device_id. However, iwl5100_agn_cfg has
type struct iwl_cfg, and yet iwl_qu_long_latency_trans_cfg is typed
struct iwl_cfg_trans_params.

  struct iwl_cfg_trans_params {
    ...
  };

  struct iwl_cfg {
    struct iwl_cfg_trans_params trans;
    const char *name;
    const char *fw_name_pre;
    ...
  };

It's fine to cast a pointer to struct iwl_cfg, but it's not always valid
to cast a struct iwl_cfg_trans_params to struct iwl_cfg.

In function iwl_pci_probe, it tries to find an alternative cfg by
iterating throughout iwl_dev_info_table, but in our case, [8086:43f0]
subsystem [1a56:1652], there will be no match in all of the candidates,
and iwl_qu_long_latency_trans_cfg will be assigned as the ultimate
struct iwl_cfg, which will be certainly wrong when you're trying to
dereference anything beyond sizeof(struct iwl_cfg_trans_params), e.g.
cfg->fw_name_pre.

In this case, ((struct
iwl_cfg_trans_params*)&iwl_qu_long_latency_trans_cfg)->name will be "'",
and ((struct
iwl_cfg_trans_params*)&iwl_qu_long_latency_trans_cfg)->fw_name_pre gives
"(efault)", pure garbage data.

So is there something missed in the iwl_dev_info_table, or better, just
find another solid safe way to handle such trans/cfg mix?

Regards,
You-Sheng Yang
