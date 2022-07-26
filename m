Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE08581461
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 15:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbiGZNox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiGZNoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:44:46 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5B82AE12
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:44:40 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 141so722172ybn.4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvftHv5S2CPX+wX4bNXzhRK6/q7KB8A8GqY7VENMb0E=;
        b=oGu5QEUIDXbi9bXA+bsBGH18wXwdHIldQcXCxwozNvjE0NannU7jy7HUEeHvw8Q7v9
         vtTDQPNGfZTyjn0R7Y9S5I8vzJ4MgNv/OWWub5/Z10egQ+O51Ps0QfCK+p2wFoklHl5N
         D0wMDHmLcvTEArg88P26Ex8K1soHGCxu3COv/r6dMlX0/i2OU3VtRjPAU96/5VLXIY2/
         nckM6oRUnTIgFUOtRn20qp1G3I9vhyiAdPND/plsSwlRHZ8u6NCM47IDNKPsC381iHGe
         jM1Sts2DknBZm4N238HKeLTsJendspw3nt7fGZhFwcZFsCmRWtqnwTSzyYpyORRYB2gl
         hgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvftHv5S2CPX+wX4bNXzhRK6/q7KB8A8GqY7VENMb0E=;
        b=QmOMjQ7O3zAff0du7a4wcostFU4cLYgfoUNAKwYvFrZc6HdZnv76eQRQjYM4UrFN+o
         ziGaeAhnYNOcgNw8UK9TnhxOYQcoj9AksdPzvVwqJ0ZwmY44veijLyn5mJ2kwnM2szHL
         YHy6l2dFpvjGOvEZ05YZwi70d74INQXAf3IVGheWz94Ml8OSAGaDZqtT3ckntsM1aZMr
         6AXDfsea1FTPJToxDnMil+Rdjh0ACmUUsKIW33izMcSkPvNQ5qMJFI9YIQ77AcV06IpE
         +CuIlljYS9iiSzHtguHXBjko1a2y/HY/xErNnkEfzX2UdGvVlvaWWZqpsE7moSlXQkO8
         Cy0w==
X-Gm-Message-State: AJIora9cTV6CHUVnZgRGQkYJLw2CdfQFknGlJbxlkmMHeupDIcBJYJIn
        QLWlOUS7Fe2bYfenwcCasLoGgS+KphXnL2/QHQE3Vw==
X-Google-Smtp-Source: AGRyM1u3i9qwV0ASbN1lQC0BslXs74W5AdhtZxPELWNuy1R08nhmr2uchgmM0eRBH5ope0qZw/ILdRvpER5SepSCyuU=
X-Received: by 2002:a25:2603:0:b0:66f:774d:e222 with SMTP id
 m3-20020a252603000000b0066f774de222mr13167407ybm.407.1658843079545; Tue, 26
 Jul 2022 06:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+-THx+jTzsLDxaX9diV4hz7z4mYqwn2CjtydFp+U4gow@mail.gmail.com>
 <de16c149-2d93-c5d5-3eda-6751c593d996@gmail.com>
In-Reply-To: <de16c149-2d93-c5d5-3eda-6751c593d996@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 15:44:28 +0200
Message-ID: <CANn89i+Mvrpryyy_My0s3MXfY=a7bpsQwQX5M64xxxbB0yfFtA@mail.gmail.com>
Subject: Re: [PATCH] net: rose: fix unregistered netdevice: waiting for rose0
 to become free
To:     Bernard F6BVP <bernard.f6bvp@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Bernard f6bvp <f6bvp@free.fr>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 1:21 PM Bernard F6BVP <bernard.f6bvp@gmail.com> wrote:
>
>
> I modified .config according to
> CONFIG_NET_DEV_REFCNT_TRACKER=y
> then compiled moduled and ran my usual AX25 and ROSE applications.
>
> Attached is (I hope) relevant dmesg dump.

Thanks !

There are a lot of problems really...

FIrst one being in ax25:

[  205.798723] reference already released.
[  205.798732] allocated in:
[  205.798734]  ax25_bind+0x1a2/0x230 [ax25]
[  205.798747]  __sys_bind+0xea/0x110
[  205.798753]  __x64_sys_bind+0x18/0x20
[  205.798758]  do_syscall_64+0x5c/0x80
[  205.798763]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  205.798768] freed in:
[  205.798770]  ax25_release+0x115/0x370 [ax25]
[  205.798778]  __sock_release+0x42/0xb0
[  205.798782]  sock_close+0x15/0x20
[  205.798785]  __fput+0x9f/0x260
[  205.798789]  ____fput+0xe/0x10
[  205.798792]  task_work_run+0x64/0xa0
[  205.798798]  exit_to_user_mode_prepare+0x18b/0x190
[  205.798804]  syscall_exit_to_user_mode+0x26/0x40
[  205.798808]  do_syscall_64+0x69/0x80
[  205.798812]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  205.798827] ------------[ cut here ]------------
[  205.798829] WARNING: CPU: 2 PID: 2605 at lib/ref_tracker.c:136
ref_tracker_free.cold+0x60/0x81
[  205.798837] Modules linked in: rose netrom mkiss ax25 rfcomm cmac
algif_hash algif_skcipher af_alg bnep snd_hda_codec_hdmi nls_iso8859_1
i915 rtw88_8821ce rtw88_8821c x86_pkg_temp_thermal rtw88_pci
intel_powerclamp rtw88_core snd_hda_codec_realtek
snd_hda_codec_generic ledtrig_audio coretemp snd_hda_intel kvm_intel
snd_intel_dspcfg mac80211 snd_hda_codec kvm i2c_algo_bit drm_buddy
drm_dp_helper btusb drm_kms_helper snd_hwdep btrtl snd_hda_core btbcm
joydev crct10dif_pclmul btintel crc32_pclmul ghash_clmulni_intel
mei_hdcp btmtk intel_rapl_msr aesni_intel bluetooth input_leds snd_pcm
crypto_simd syscopyarea processor_thermal_device_pci_legacy
sysfillrect cryptd intel_soc_dts_iosf snd_seq sysimgblt ecdh_generic
fb_sys_fops rapl libarc4 processor_thermal_device intel_cstate
processor_thermal_rfim cec snd_timer ecc snd_seq_device cfg80211
processor_thermal_mbox mei_me processor_thermal_rapl mei rc_core at24
snd intel_pch_thermal intel_rapl_common ttm soundcore
int340x_thermal_zone video
[  205.798948]  mac_hid acpi_pad sch_fq_codel ipmi_devintf
ipmi_msghandler drm msr parport_pc ppdev lp parport ramoops pstore_blk
reed_solomon pstore_zone efi_pstore ip_tables x_tables autofs4
hid_generic usbhid hid i2c_i801 i2c_smbus r8169 xhci_pci ahci libahci
realtek lpc_ich xhci_pci_renesas [last unloaded: ax25]
[  205.798992] CPU: 2 PID: 2605 Comm: ax25ipd Not tainted 5.18.11-F6BVP #3
[  205.798996] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./CK3, BIOS 5.011 09/16/2020
[  205.798999] RIP: 0010:ref_tracker_free.cold+0x60/0x81
[  205.799005] Code: e8 d2 01 9b ff 83 7b 18 00 74 14 48 c7 c7 2f d7
ff 98 e8 10 6e fc ff 8b 7b 18 e8 b8 01 9b ff 4c 89 ee 4c 89 e7 e8 5d
fd 07 00 <0f> 0b b8 ea ff ff ff e9 30 05 9b ff 41 0f b6 f7 48 c7 c7 a0
fa 4e
[  205.799008] RSP: 0018:ffffaf5281073958 EFLAGS: 00010286
[  205.799011] RAX: 0000000080000000 RBX: ffff9a0bd687ebe0 RCX: 0000000000000000
[  205.799014] RDX: 0000000000000001 RSI: 0000000000000282 RDI: 00000000ffffffff
[  205.799016] RBP: ffffaf5281073a10 R08: 0000000000000003 R09: fffffffffffd5618
[  205.799019] R10: 0000000000ffff10 R11: 000000000000000f R12: ffff9a0bc53384d0
[  205.799022] R13: 0000000000000282 R14: 00000000ae000001 R15: 0000000000000001
[  205.799024] FS:  0000000000000000(0000) GS:ffff9a0d0f300000(0000)
knlGS:0000000000000000
[  205.799028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  205.799031] CR2: 00007ff6b8311554 CR3: 000000001ac10004 CR4: 00000000001706e0
[  205.799033] Call Trace:
[  205.799035]  <TASK>
[  205.799038]  ? ax25_dev_device_down+0xd9/0x1b0 [ax25]
[  205.799047]  ? ax25_device_event+0x9f/0x270 [ax25]
[  205.799055]  ? raw_notifier_call_chain+0x49/0x60
[  205.799060]  ? call_netdevice_notifiers_info+0x52/0xa0
[  205.799065]  ? dev_close_many+0xc8/0x120
[  205.799070]  ? unregister_netdevice_many+0x13d/0x890
[  205.799073]  ? unregister_netdevice_queue+0x90/0xe0
[  205.799076]  ? unregister_netdev+0x1d/0x30
[  205.799080]  ? mkiss_close+0x7c/0xc0 [mkiss]
[  205.799084]  ? tty_ldisc_close+0x2e/0x40
[  205.799089]  ? tty_ldisc_hangup+0x137/0x210
[  205.799092]  ? __tty_hangup.part.0+0x208/0x350
[  205.799098]  ? tty_vhangup+0x15/0x20
[  205.799103]  ? pty_close+0x127/0x160
[  205.799108]  ? tty_release+0x139/0x5e0
[  205.799112]  ? __fput+0x9f/0x260
[  205.799118]  ax25_dev_device_down+0xd9/0x1b0 [ax25]
[  205.799126]  ax25_device_event+0x9f/0x270 [ax25]
[  205.799135]  raw_notifier_call_chain+0x49/0x60
[  205.799140]  call_netdevice_notifiers_info+0x52/0xa0
[  205.799146]  dev_close_many+0xc8/0x120
[  205.799152]  unregister_netdevice_many+0x13d/0x890
[  205.799157]  unregister_netdevice_queue+0x90/0xe0
[  205.799161]  unregister_netdev+0x1d/0x30
[  205.799165]  mkiss_close+0x7c/0xc0 [mkiss]
[  205.799170]  tty_ldisc_close+0x2e/0x40
[  205.799173]  tty_ldisc_hangup+0x137/0x210
[  205.799178]  __tty_hangup.part.0+0x208/0x350
[  205.799184]  tty_vhangup+0x15/0x20
[  205.799188]  pty_close+0x127/0x160
[  205.799193]  tty_release+0x139/0x5e0
[  205.799199]  __fput+0x9f/0x260
[  205.799203]  ____fput+0xe/0x10
[  205.799208]  task_work_run+0x64/0xa0
[  205.799213]  do_exit+0x33b/0xab0
[  205.799217]  ? __handle_mm_fault+0xc4f/0x15f0
[  205.799224]  do_group_exit+0x35/0xa0
[  205.799228]  __x64_sys_exit_group+0x18/0x20
[  205.799232]  do_syscall_64+0x5c/0x80
[  205.799238]  ? handle_mm_fault+0xba/0x290
[  205.799242]  ? debug_smp_processor_id+0x17/0x20
[  205.799246]  ? fpregs_assert_state_consistent+0x26/0x50
[  205.799251]  ? exit_to_user_mode_prepare+0x49/0x190
[  205.799256]  ? irqentry_exit_to_user_mode+0x9/0x20
[  205.799260]  ? irqentry_exit+0x33/0x40
[  205.799263]  ? exc_page_fault+0x87/0x170
[  205.799268]  ? asm_exc_page_fault+0x8/0x30
[  205.799273]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  205.799277] RIP: 0033:0x7ff6b80eaca1
[  205.799281] Code: Unable to access opcode bytes at RIP 0x7ff6b80eac77.
[  205.799283] RSP: 002b:00007fff6dfd4738 EFLAGS: 00000246 ORIG_RAX:
00000000000000e7
[  205.799287] RAX: ffffffffffffffda RBX: 00007ff6b8215a00 RCX: 00007ff6b80eaca1
[  205.799290] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
[  205.799293] RBP: 0000000000000001 R08: ffffffffffffff80 R09: 0000000000000028
[  205.799295] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff6b8215a00
[  205.799298] R13: 0000000000000000 R14: 00007ff6b821aee8 R15: 00007ff6b821af00
[  205.799304]  </TASK>
