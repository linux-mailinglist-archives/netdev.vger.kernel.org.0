Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED2FB004
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfKMLwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:52:04 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38864 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfKMLwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 06:52:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id z19so1681666wmk.3
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 03:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=X0WCZIxLwelKM3WmRCZtp59hC7WQmrls8oeH5x6dh04=;
        b=T1SQwl5Y7EEiL0NJiYCAyoAiAfvqzQrib3hrRs68yODzV/V9d6pB2ml/n25T7SaFO3
         XP3P3H8habXE4NxhAV0/V1nDbP+nB6wnDI4EHciMDVtvVoZVmEPv5CDO7zrnxZKiEYIY
         LIi3EMOh1+hQ9lecF6SboCxK6mXe5m1Iblmt69Yk9qlhZNjbF5KTTr9oAr+kTmp7zX2M
         pgtQ7lJ0XK7ENGClhjw+B+MrIZ/32tvp32bZhyJ1lykpT7JziQHxUuP+vNmyLc2tqztP
         qIPuWB/MYzCrSIoLLEunsKA+9/KUfHbDbPI6ba+2RTmdnIB+dcwBM5T4OvCUn+2/glrd
         SmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=X0WCZIxLwelKM3WmRCZtp59hC7WQmrls8oeH5x6dh04=;
        b=MP5SEG0B4nUKcCgTlaHYthWJfBfHAq6ifyfqqEpdDmor/oIvyE7Rnz/TjegxGdsb42
         TCtRo5NkOO87+UN4JFpOSZr5wYCBuykIJ7QfmQinwQFi1rELLHKF8QzVIIzjs+LsS1xa
         +JXDGy3GbD73lHKtNoX56WK2AvWTDeIJAmsi9+bh9EEXmiyLn01lgg1BsZtPK0gRWQFR
         SSFpQmfgoKFMPuDd/SJrGgOIKWhwno2zn+ASciAUuAL4NVNsQ2kXetCAV7qtfIOEtR/s
         xwZGq42WbidsmhVMC5RABne3NNHQntGkmiCt+4s6javRMhewDG6PhODePkDV2XpJQReT
         ZaQg==
X-Gm-Message-State: APjAAAXS+ltmjpKqf1R+AFLZ8a0arV7RW6K5qZWHg9g/zAwCLhtDxc8K
        jsXpsNxg+f6XokqhvZNKW6ZQzw==
X-Google-Smtp-Source: APXvYqyfkDJyu/fHtWbKZACEiLT23cQk+OHB11HOhkccvilGeEo8fHkwfe+3Ip0oX6ndKVdK8fGvGw==
X-Received: by 2002:a7b:ce90:: with SMTP id q16mr2366270wmj.172.1573645921415;
        Wed, 13 Nov 2019 03:52:01 -0800 (PST)
Received: from [192.168.3.176] (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id w4sm1824289wmi.39.2019.11.13.03.52.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 03:52:00 -0800 (PST)
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Greg KH <greg@kroah.com>
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
Subject: crash since commit "net/flow_dissector: switch to siphash"
Message-ID: <cc0add2f-4ae7-70cb-2c98-242d0f0aede9@ncentric.com>
Date:   Wed, 13 Nov 2019 12:52:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I'm currently testing kernel 4.14.153 bump for OpenWrt and noticed splat 
below on my testing boards.
They all reboot continuously nearly immediately when linked.

It feels like it's tied to a commit of yours [1]

Any idea?

If you need more info, please let me know.

Thanks,

Koen


[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.154&id=a9de6f42e945cdb24b59c7ab7ebad1eba6cb5875


[   48.269789] wlan0: Trigger new scan to find an IBSS to join
[   48.680754] wlan0: Trigger new scan to find an IBSS to join
[   49.041907] wlan0: Trigger new scan to find an IBSS to join
[   49.079668] wlan0: Trigger new scan to find an IBSS to join
[   49.149738] wlan0: Selected IBSS BSSID 16:5b:94:39:cb:5f based on 
configured SSID
[   49.199633] Unhandled kernel unaligned access[#1]:
[   49.204505] CPU: 0 PID: 1634 Comm: wpa_supplicant Tainted: G        
W       4.14.153 #0
[   49.212619] task: 87d14580 task.stack: 860c6000
[   49.217209] $ 0   : 00000000 77ea0b33 00000000 ceb5840c
[   49.222515] $ 4   : 860c7a78 00000014 67aae3bf 00000000
[   49.227821] $ 8   : 00000000 8040c9b0 87d1e460 0000d000
[   49.233128] $12   : 74650000 00000000 00000001 00000002
[   49.238435] $16   : 0000fffe 804f0000 67aae3bf 8766e5a4
[   49.243741] $20   : 00000000 804f0000 804f3978 87d1e054
[   49.249048] $24   : 00000002 00000003
[   49.254353] $28   : 860c6000 860c7a30 00000000 8032cff8
[   49.259661] Hi    : 00000050
[   49.262573] Lo    : 00000002
[   49.265500] epc   : 804061a4 __siphash_aligned+0x24/0x730
[   49.270985] ra    : 8032cff8 skb_get_hash_perturb+0x160/0x1a8
[   49.276803] Status: 1100dc03 KERNEL EXL IE
[   49.281045] Cause : 00800010 (ExcCode 04)
[   49.285110] BadVA : 67aae3c7
[   49.288024] PrId  : 00019750 (MIPS 74Kc)
[   49.291990] Modules linked in: mbt ath9k ath9k_common qcserial pppoe 
ppp_async option cdc_mbim ath9k_hw ath10k_pci ath10k_core ath usb_wwan 
sierra_net sierra rndis_host qmi_wwan pppox ppp_generic mac80211 
iptable_nat iptable_mangle iptable_filter ipt_REJECT ipt_MASQUERADE 
ip_tables huawei_cdc_ncm ftdi_sio cfg80211 cdc_subset cdc_ncm cdc_ether 
xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_lim2
[   49.363914]  cls_tcindex cls_route cls_matchall cls_fw cls_flow 
cls_basic act_skbedit act_mirred i2c_dev ledtrig_usbport cryptodev msdos 
bonding ip_gre gre dummy udp_tunnel ip_tunnel tun vfat fat nls_utf8 
nls_iso8859_1 nls_cp437 authenc ehci_platform sd_mod scsi_mod ehci_hcd 
gpio_button_hotplug ext4 mbcache jbd2 usbcore nls_base usb_common ptp 
pps_core mii aead crypto_null cryptomgr crc32c_generic crypto_hash
[   49.400738] Process wpa_supplicant (pid: 1634, threadinfo=860c6000, 
task=87d14580, tls=77f6defc)
[   49.409638] Stack : 67aae3bf 0000fffe 804f0000 67aae3bf 8766e5a4 
00000000 804f0000 804f3978
[   49.418121]         00000056 80580000 879b84c8 879cb088 00000000 
00000000 00000085 00000004
[   49.426604]         00220000 00000000 888e0000 00000000 00000000 
00000000 00000000 00000000
[   49.435087]         00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   49.443570]         860c7b68 ceb5840c 86cb0bc0 860c2300 8766e508 
86d2b604 879cb088 8793a750
[   49.452053]         ...
[   49.454537] Call Trace:
[   49.457014] [<804061a4>] __siphash_aligned+0x24/0x730
[   49.462146] [<8032cff8>] skb_get_hash_perturb+0x160/0x1a8
[   49.467737] [<86d2b604>] ieee80211_reserve_tid+0x26c/0xeb8 [mac80211]
[   49.474300] Code: afb2000c  afb10008  afb00004 <8cd40008> 8cc90000  
3c136c79  3c02646f  3c07736f  24427261
[   49.484200]
[   49.485774] ---[ end trace ec8947d373843bf7 ]---
[   49.492228] Kernel panic - not syncing: Fatal exception in interrupt
[   49.499642] Rebooting in 3 seconds..

