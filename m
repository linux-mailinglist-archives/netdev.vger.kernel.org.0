Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C9258874E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 08:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiHCGXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 02:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiHCGXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 02:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5D5A422D6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 23:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659507820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hLdeJklVfNXxQYV/9noiVQzCnCbeoCx/MeEWH/uWPtE=;
        b=ahcWNmq9dmw+xfD8ja1ZbpW5MEZP7xQQYI4nfEIaALc7g11CE2V1OYPq82rIM8Ovug//9F
        S9G0uLrPRcKRoNGZlscD/Ouqlt1eagfsg5V9mPUoB+NJ3ZgavYaS0jS3R9Yxe+1j8Rt/S/
        ap6D8EixOwfSZBH4QsesM0TI82+620g=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-BIJDfxGfM2ew8tkar3wz1w-1; Wed, 03 Aug 2022 02:23:39 -0400
X-MC-Unique: BIJDfxGfM2ew8tkar3wz1w-1
Received: by mail-qv1-f69.google.com with SMTP id q1-20020a056214018100b0047464a85fc4so9379648qvr.7
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 23:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hLdeJklVfNXxQYV/9noiVQzCnCbeoCx/MeEWH/uWPtE=;
        b=i8WtqmuWo69CgSWm9oQxpKrYsmvgQCWLkwdQUG0yydlvuA3n12qfazOdF363TGg489
         C8fIgaSFLfAq38UtCQnGosOh2Asuo9RXgG+Dbr/LQchEAflAMwlqAXOSp9urFAxboXTJ
         /GyUVYRMW6Rs7IBMevhjM5SSDCKGd2zoxItN+hu+Okjjfv6hXmzFrZgNtdMTojSfUZVT
         3cS75NVsE4WxWAP3XEqNJvVUlVhTgWgtoZ/1xNN4XUJwdisvy8dBOcIaTwFLMRGRIpc5
         hT9SUznT9qnFVNGGiotoOgQI51vZcvuiefL/xbaTiTf/FW4xnGay1mVcOuNBp2dgfyjS
         V/jQ==
X-Gm-Message-State: AJIora98O8/IoZy42HLUvYhHgvRNd1dICS4mXF05JpRuxnngoT2EKU2L
        Yfgshne9W1He97Lx3aXBsVJZ8Rfc/1o480ynBA6G6fg0yyLUhYdLUeRzq+iNDpNc0cWsLKMYTZY
        m58GNf5mbxOg/JHzW
X-Received: by 2002:a05:620a:40c6:b0:6b6:7bba:5724 with SMTP id g6-20020a05620a40c600b006b67bba5724mr17269873qko.163.1659507819234;
        Tue, 02 Aug 2022 23:23:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tyg++1gFlRU6HJsWVkazuEQGf9ioWlAKWqphQ89B46l7YygpQ49hAw0I45Z38++W/GtPDwhQ==
X-Received: by 2002:a05:620a:40c6:b0:6b6:7bba:5724 with SMTP id g6-20020a05620a40c600b006b67bba5724mr17269866qko.163.1659507818946;
        Tue, 02 Aug 2022 23:23:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id n17-20020a05622a041100b0031eebfcb369sm10811911qtx.97.2022.08.02.23.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 23:23:38 -0700 (PDT)
Message-ID: <c1b350f033f0e07f45351689499bbed98b987f3e.camel@redhat.com>
Subject: Re: [PATCH net] ax25: fix incorrect dev_tracker usage
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Bernard F6BVP <f6bvp@free.fr>,
        Duoming Zhou <duoming@zju.edu.cn>
Date:   Wed, 03 Aug 2022 08:23:34 +0200
In-Reply-To: <20220728051821.3160118-1-eric.dumazet@gmail.com>
References: <20220728051821.3160118-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-27 at 22:18 -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>=20
> While investigating a separate rose issue [1], and enabling
> CONFIG_NET_DEV_REFCNT_TRACKER=3Dy, Bernard reported an orthogonal ax25 is=
sue [2]
>=20
> An ax25_dev can be used by one (or many) struct ax25_cb.
> We thus need different dev_tracker, one per struct ax25_cb.
>=20
> After this patch is applied, we are able to focus on rose.
>=20
> [1] https://lore.kernel.org/netdev/fb7544a1-f42e-9254-18cc-c9b071f4ca70@f=
ree.fr/
>=20
> [2]
> [  205.798723] reference already released.
> [  205.798732] allocated in:
> [  205.798734]  ax25_bind+0x1a2/0x230 [ax25]
> [  205.798747]  __sys_bind+0xea/0x110
> [  205.798753]  __x64_sys_bind+0x18/0x20
> [  205.798758]  do_syscall_64+0x5c/0x80
> [  205.798763]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  205.798768] freed in:
> [  205.798770]  ax25_release+0x115/0x370 [ax25]
> [  205.798778]  __sock_release+0x42/0xb0
> [  205.798782]  sock_close+0x15/0x20
> [  205.798785]  __fput+0x9f/0x260
> [  205.798789]  ____fput+0xe/0x10
> [  205.798792]  task_work_run+0x64/0xa0
> [  205.798798]  exit_to_user_mode_prepare+0x18b/0x190
> [  205.798804]  syscall_exit_to_user_mode+0x26/0x40
> [  205.798808]  do_syscall_64+0x69/0x80
> [  205.798812]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  205.798827] ------------[ cut here ]------------
> [  205.798829] WARNING: CPU: 2 PID: 2605 at lib/ref_tracker.c:136 ref_tra=
cker_free.cold+0x60/0x81
> [  205.798837] Modules linked in: rose netrom mkiss ax25 rfcomm cmac algi=
f_hash algif_skcipher af_alg bnep snd_hda_codec_hdmi nls_iso8859_1 i915 rtw=
88_8821ce rtw88_8821c x86_pkg_temp_thermal rtw88_pci intel_powerclamp rtw88=
_core snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio coretemp sn=
d_hda_intel kvm_intel snd_intel_dspcfg mac80211 snd_hda_codec kvm i2c_algo_=
bit drm_buddy drm_dp_helper btusb drm_kms_helper snd_hwdep btrtl snd_hda_co=
re btbcm joydev crct10dif_pclmul btintel crc32_pclmul ghash_clmulni_intel m=
ei_hdcp btmtk intel_rapl_msr aesni_intel bluetooth input_leds snd_pcm crypt=
o_simd syscopyarea processor_thermal_device_pci_legacy sysfillrect cryptd i=
ntel_soc_dts_iosf snd_seq sysimgblt ecdh_generic fb_sys_fops rapl libarc4 p=
rocessor_thermal_device intel_cstate processor_thermal_rfim cec snd_timer e=
cc snd_seq_device cfg80211 processor_thermal_mbox mei_me processor_thermal_=
rapl mei rc_core at24 snd intel_pch_thermal intel_rapl_common ttm soundcore=
 int340x_thermal_zone video
> [  205.798948]  mac_hid acpi_pad sch_fq_codel ipmi_devintf ipmi_msghandle=
r drm msr parport_pc ppdev lp parport ramoops pstore_blk reed_solomon pstor=
e_zone efi_pstore ip_tables x_tables autofs4 hid_generic usbhid hid i2c_i80=
1 i2c_smbus r8169 xhci_pci ahci libahci realtek lpc_ich xhci_pci_renesas [l=
ast unloaded: ax25]
> [  205.798992] CPU: 2 PID: 2605 Comm: ax25ipd Not tainted 5.18.11-F6BVP #=
3
> [  205.798996] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./CK3, BIOS 5.011 09/16/2020
> [  205.798999] RIP: 0010:ref_tracker_free.cold+0x60/0x81
> [  205.799005] Code: e8 d2 01 9b ff 83 7b 18 00 74 14 48 c7 c7 2f d7 ff 9=
8 e8 10 6e fc ff 8b 7b 18 e8 b8 01 9b ff 4c 89 ee 4c 89 e7 e8 5d fd 07 00 <=
0f> 0b b8 ea ff ff ff e9 30 05 9b ff 41 0f b6 f7 48 c7 c7 a0 fa 4e
> [  205.799008] RSP: 0018:ffffaf5281073958 EFLAGS: 00010286
> [  205.799011] RAX: 0000000080000000 RBX: ffff9a0bd687ebe0 RCX: 000000000=
0000000
> [  205.799014] RDX: 0000000000000001 RSI: 0000000000000282 RDI: 00000000f=
fffffff
> [  205.799016] RBP: ffffaf5281073a10 R08: 0000000000000003 R09: fffffffff=
ffd5618
> [  205.799019] R10: 0000000000ffff10 R11: 000000000000000f R12: ffff9a0bc=
53384d0
> [  205.799022] R13: 0000000000000282 R14: 00000000ae000001 R15: 000000000=
0000001
> [  205.799024] FS:  0000000000000000(0000) GS:ffff9a0d0f300000(0000) knlG=
S:0000000000000000
> [  205.799028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  205.799031] CR2: 00007ff6b8311554 CR3: 000000001ac10004 CR4: 000000000=
01706e0
> [  205.799033] Call Trace:
> [  205.799035]  <TASK>
> [  205.799038]  ? ax25_dev_device_down+0xd9/0x1b0 [ax25]
> [  205.799047]  ? ax25_device_event+0x9f/0x270 [ax25]
> [  205.799055]  ? raw_notifier_call_chain+0x49/0x60
> [  205.799060]  ? call_netdevice_notifiers_info+0x52/0xa0
> [  205.799065]  ? dev_close_many+0xc8/0x120
> [  205.799070]  ? unregister_netdevice_many+0x13d/0x890
> [  205.799073]  ? unregister_netdevice_queue+0x90/0xe0
> [  205.799076]  ? unregister_netdev+0x1d/0x30
> [  205.799080]  ? mkiss_close+0x7c/0xc0 [mkiss]
> [  205.799084]  ? tty_ldisc_close+0x2e/0x40
> [  205.799089]  ? tty_ldisc_hangup+0x137/0x210
> [  205.799092]  ? __tty_hangup.part.0+0x208/0x350
> [  205.799098]  ? tty_vhangup+0x15/0x20
> [  205.799103]  ? pty_close+0x127/0x160
> [  205.799108]  ? tty_release+0x139/0x5e0
> [  205.799112]  ? __fput+0x9f/0x260
> [  205.799118]  ax25_dev_device_down+0xd9/0x1b0 [ax25]
> [  205.799126]  ax25_device_event+0x9f/0x270 [ax25]
> [  205.799135]  raw_notifier_call_chain+0x49/0x60
> [  205.799140]  call_netdevice_notifiers_info+0x52/0xa0
> [  205.799146]  dev_close_many+0xc8/0x120
> [  205.799152]  unregister_netdevice_many+0x13d/0x890
> [  205.799157]  unregister_netdevice_queue+0x90/0xe0
> [  205.799161]  unregister_netdev+0x1d/0x30
> [  205.799165]  mkiss_close+0x7c/0xc0 [mkiss]
> [  205.799170]  tty_ldisc_close+0x2e/0x40
> [  205.799173]  tty_ldisc_hangup+0x137/0x210
> [  205.799178]  __tty_hangup.part.0+0x208/0x350
> [  205.799184]  tty_vhangup+0x15/0x20
> [  205.799188]  pty_close+0x127/0x160
> [  205.799193]  tty_release+0x139/0x5e0
> [  205.799199]  __fput+0x9f/0x260
> [  205.799203]  ____fput+0xe/0x10
> [  205.799208]  task_work_run+0x64/0xa0
> [  205.799213]  do_exit+0x33b/0xab0
> [  205.799217]  ? __handle_mm_fault+0xc4f/0x15f0
> [  205.799224]  do_group_exit+0x35/0xa0
> [  205.799228]  __x64_sys_exit_group+0x18/0x20
> [  205.799232]  do_syscall_64+0x5c/0x80
> [  205.799238]  ? handle_mm_fault+0xba/0x290
> [  205.799242]  ? debug_smp_processor_id+0x17/0x20
> [  205.799246]  ? fpregs_assert_state_consistent+0x26/0x50
> [  205.799251]  ? exit_to_user_mode_prepare+0x49/0x190
> [  205.799256]  ? irqentry_exit_to_user_mode+0x9/0x20
> [  205.799260]  ? irqentry_exit+0x33/0x40
> [  205.799263]  ? exc_page_fault+0x87/0x170
> [  205.799268]  ? asm_exc_page_fault+0x8/0x30
> [  205.799273]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  205.799277] RIP: 0033:0x7ff6b80eaca1
> [  205.799281] Code: Unable to access opcode bytes at RIP 0x7ff6b80eac77.
> [  205.799283] RSP: 002b:00007fff6dfd4738 EFLAGS: 00000246 ORIG_RAX: 0000=
0000000000e7
> [  205.799287] RAX: ffffffffffffffda RBX: 00007ff6b8215a00 RCX: 00007ff6b=
80eaca1
> [  205.799290] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 000000000=
0000001
> [  205.799293] RBP: 0000000000000001 R08: ffffffffffffff80 R09: 000000000=
0000028
> [  205.799295] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff6b=
8215a00
> [  205.799298] R13: 0000000000000000 R14: 00007ff6b821aee8 R15: 00007ff6b=
821af00
> [  205.799304]  </TASK>
>=20
> Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebindin=
g operation")
> Reported-by: Bernard F6BVP <f6bvp@free.fr>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  include/net/ax25.h | 1 +
>  net/ax25/af_ax25.c | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/net/ax25.h b/include/net/ax25.h
> index a427a05672e2aab158efd44381fe2190d9cb8969..f8cf3629a41934f96f33e5d70=
ad90cc8ae796d38 100644
> --- a/include/net/ax25.h
> +++ b/include/net/ax25.h
> @@ -236,6 +236,7 @@ typedef struct ax25_cb {
>  	ax25_address		source_addr, dest_addr;
>  	ax25_digi		*digipeat;
>  	ax25_dev		*ax25_dev;
> +	netdevice_tracker	dev_tracker;
>  	unsigned char		iamdigi;
>  	unsigned char		state, modulus, pidincl;
>  	unsigned short		vs, vr, va;

I'm sorry for the [too] late feedback, but it looks like this patch
forgot to remove the old/unused tracker from ax25_dev, or am I missing
something?

Thanks!

Paolo

