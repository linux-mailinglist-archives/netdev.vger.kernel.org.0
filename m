Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B39F54A1EE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 00:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiFMWLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 18:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiFMWLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 18:11:06 -0400
X-Greylist: delayed 485 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Jun 2022 15:11:03 PDT
Received: from hannover.ccc.de (ep.leitstelle511.net [80.147.51.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6548511C34
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 15:11:03 -0700 (PDT)
Date:   Tue, 14 Jun 2022 00:02:51 +0200
From:   Ingo Saitz <ingo@hannover.ccc.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: bhash2 WARN_ON call in net/ipv4/inet_connection_sock.c:525
 inet_csk_get_port
Message-ID: <Yqe0CwZhha8o5t4G@pinguin.zoo>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SmY/0OTJntqgy1vw"
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SmY/0OTJntqgy1vw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Linux v5.19-rc2 I noticed a WARN_ON() message during the start of the
rsync daemon. The bug was introduced by commit
d5a42de8bdbe25081f07b801d8b35f4d75a791f4 "net: Add a second bind table
hashed by port and address", reverting it caused the warning to go away.
The warning message from the dmesg is attached

I added a reproduce.c which reproduces the same warning everytime it is
called, even as user.

I also reproduced the same problem on the current netdev git, see 2nd
attached dmesg.
git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
commit 619c010a65391d06bc96e79fa0e7725790e5d1a9

    Ingo
-- 
Kennedy's Lemma:
    If you can parse Perl, you can solve the Halting Problem.

http://www.perlmonks.org/?node_id=663393

--SmY/0OTJntqgy1vw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="WARN-5.19-rc2.txt"

[   37.880931] ------------[ cut here ]------------
[   37.880935] WARNING: CPU: 0 PID: 2673 at net/ipv4/inet_connection_sock.c:525 inet_csk_get_port+0x5d7/0x7c0
[   37.882679] Modules linked in: xt_LOG nf_log_syslog xt_pkttype xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_limit xt_limit ip6_tables ip6t_REJECT nf_reject_ipv6 xt
_tcpudp nft_compat nf_tables x_tables nfnetlink tcp_bbr sch_fq isofs drivetemp nct6775 nct6775_core hwmon_vid wmi tun ipv6 loop parport_pc ppdev lp parport dm_crypt cbc encrypted_ke
ys snd_hda_codec_hdmi i915 coretemp hwmon snd_hda_codec_realtek intel_rapl_msr intel_rapl_common i2c_algo_bit snd_hda_codec_generic intel_gtt x86_pkg_temp_thermal drm_buddy drm_disp
lay_helper intel_powerclamp ledtrig_audio drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops kvm_intel mei_hdcp ttm kvm r8169 snd_hda_intel drm realtek mdio_devres snd_int
el_dspcfg libphy snd_hda_codec irqbypass drm_panel_orientation_quirks i2c_i801 snd_hwdep evdev input_leds lpc_ich led_class i2c_smbus mei_me snd_hda_core mfd_core rtc_cmos snd_pcm m
ei sg i2c_core snd_timer button acpi_pad pcspkr video snd soundcore raid1 dm_raid raid456 libcrc32c
[   37.882802]  async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq md_mod hid_generic usbhid hid crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
cryptd serio_raw xhci_pci ehci_pci xhci_hcd ehci_hcd sr_mod cdrom usbcore usb_common unix dm_mirror dm_region_hash dm_log dm_mod
[   37.886904] CPU: 0 PID: 2673 Comm: rsync Tainted: G                T 5.19.0-rc2-pinguin20220613 #1
[   37.888630] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H97 Anniversary, BIOS P1.20 12/15/2014
[   37.890552] RIP: 0010:inet_csk_get_port+0x5d7/0x7c0
[   37.892498] Code: 48 8b 54 24 58 48 8b 78 28 0f b7 cd e8 02 b5 ff ff 48 85 c0 48 89 44 24 10 0f 84 36 01 00 00 41 bd 01 00 00 00 e9 ca fd ff ff <0f> 0b e9 04 fe ff ff 0f 0b e9 e9
 fd ff ff 39 43 10 0f 85 88 fb ff
[   37.894612] RSP: 0018:ffffb86901da7d70 EFLAGS: 00010202
[   37.896794] RAX: ffff9873d21aa140 RBX: 0000000000000000 RCX: 0000000000000001
[   37.899002] RDX: 000000000000000a RSI: 00000000fffffe01 RDI: ffffffff8afcbbf0
[   37.901244] RBP: 00000000000056cc R08: 0000000000000001 R09: 0000000000000001
[   37.903508] R10: ffff9873ca7e9180 R11: 0000000000000002 R12: 0000000000000000
[   37.905779] R13: 0000000000000000 R14: ffff9873ca7e9180 R15: 0000000000000000
[   37.908076] FS:  00007f08f3af1440(0000) GS:ffff9876cfe00000(0000) knlGS:0000000000000000
[   37.910404] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.912753] CR2: 00007f08f35f97a0 CR3: 00000001034f6001 CR4: 00000000000706f0
[   37.915130] Call Trace:
[   37.917526]  <TASK>
[   37.919680]  inet_csk_listen_start+0x7a/0x100
[   37.921827]  inet_listen+0x70/0x100
[   37.924000]  __sys_listen+0x52/0xc0
[   37.925975]  __x64_sys_listen+0xb/0x40
[   37.927932]  do_syscall_64+0x5b/0xc0
[   37.929906]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   37.931731] RIP: 0033:0x7f08f3522ae7
[   37.933541] Code: f0 ff ff 73 01 c3 48 8b 0d 86 23 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 32 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b
 0d 59 23 0d 00 f7 d8 64 89 01 48
[   37.935320] RSP: 002b:00007ffcfb78b1b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
[   37.937119] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f08f3522ae7
[   37.938799] RDX: 0000000000000004 RSI: 0000000000000005 RDI: 0000000000000004
[   37.940461] RBP: 00000000ffffffff R08: 0000000000000007 R09: 00005565675959c0
[   37.942024] R10: 00007ffcfb78b1f4 R11: 0000000000000246 R12: 00007ffcfb78b1f4
[   37.943556] R13: 0000000000000000 R14: 0000000000000005 R15: 00005565675959a0
[   37.945066]  </TASK>
[   37.946561] ---[ end trace 0000000000000000 ]---

--SmY/0OTJntqgy1vw
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="reproduce.c"

#include <arpa/inet.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

/* changed from 873 to 8733, so it can run as user, the actual port does not
 * matter */
#define RSYNC_PORT (8733)

int main() {
  int so1, so2;
  int32_t optval;

  /* The following code is rewritten from a strace of rsync --daemon. */
  so1 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

  optval = 1;
  setsockopt(so1, SOL_SOCKET, SO_REUSEADDR, (void *)&optval, sizeof(optval));

  struct sockaddr_in sa1 = {.sin_family = AF_INET,
                            .sin_port = htons(RSYNC_PORT),
                            .sin_addr = inet_addr("0.0.0.0")};
  bind(so1, (struct sockaddr *)&sa1, sizeof(sa1));

  so2 = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);

  optval = 1;
  setsockopt(so2, SOL_SOCKET, SO_REUSEADDR, (void *)&optval, sizeof(optval));

  optval = 1;
  setsockopt(so2, SOL_IPV6, IPV6_V6ONLY, (void *)&optval, sizeof(optval));

  struct sockaddr_in6 sa2 = {.sin6_family = AF_INET6,
                             .sin6_port = htons(RSYNC_PORT),
                             .sin6_flowinfo = htonl(0),
                             .sin6_scope_id = 0};
  inet_pton(AF_INET6, "::", &sa2.sin6_addr);
  bind(so2, (struct sockaddr *)&sa2, sizeof(sa2));

  /* WARN_ON() is thrown here: */
  listen(so1, 5);
  /* listen(so2, 5); */
}

--SmY/0OTJntqgy1vw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="WARN-5.19-netdev-HEAD.txt"

[   36.472185] ------------[ cut here ]------------
[   36.472189] WARNING: CPU: 0 PID: 2696 at net/ipv4/inet_connection_sock.c:525 inet_csk_get_port+0x5d7/0x7c0
[   36.472776] Modules linked in: xt_LOG nf_log_syslog xt_pkttype xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_limit xt_limit ip6_tables ip6t_REJECT nf_reject_ipv6 xt
_tcpudp nft_compat nf_tables x_tables nfnetlink tcp_bbr sch_fq isofs drivetemp nct6775 nct6775_core hwmon_vid wmi tun ipv6 loop parport_pc ppdev lp parport dm_crypt cbc encrypted_ke
ys snd_hda_codec_hdmi i915 snd_hda_codec_realtek i2c_algo_bit snd_hda_codec_generic intel_gtt coretemp ledtrig_audio hwmon intel_rapl_msr drm_buddy mei_hdcp drm_display_helper intel
_rapl_common snd_hda_intel snd_intel_dspcfg x86_pkg_temp_thermal drm_kms_helper snd_hda_codec intel_powerclamp syscopyarea sysfillrect snd_hwdep sysimgblt kvm_intel fb_sys_fops ttm
snd_hda_core snd_pcm drm r8169 snd_timer kvm drm_panel_orientation_quirks evdev realtek input_leds irqbypass snd mdio_devres led_class mei_me sg mei video libphy lpc_ich mfd_core i2
c_i801 soundcore i2c_smbus rtc_cmos button i2c_core pcspkr acpi_pad raid1 dm_raid raid456 libcrc32c
[   36.472826]  async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq md_mod hid_generic usbhid hid crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
cryptd serio_raw sr_mod cdrom xhci_pci xhci_hcd ehci_pci ehci_hcd usbcore usb_common unix dm_mirror dm_region_hash dm_log dm_mod
[   36.475539] CPU: 0 PID: 2696 Comm: rsync Tainted: G                T 5.19.0-rc1-pinguin-netdev20220613 #1
[   36.475999] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H97 Anniversary, BIOS P1.20 12/15/2014
[   36.476466] RIP: 0010:inet_csk_get_port+0x5d7/0x7c0
[   36.476939] Code: 48 8b 54 24 58 48 8b 78 28 0f b7 cd e8 02 b5 ff ff 48 85 c0 48 89 44 24 10 0f 84 36 01 00 00 41 bd 01 00 00 00 e9 ca fd ff ff <0f> 0b e9 04 fe ff ff 0f 0b e9 e9
 fd ff ff 39 43 10 0f 85 88 fb ff
[   36.477454] RSP: 0018:ffffa0bd81ddfdc0 EFLAGS: 00010283
[   36.477982] RAX: ffff8fced2893340 RBX: 0000000000000000 RCX: 0000000000000001
[   36.478520] RDX: 000000000000000a RSI: 00000000fffffe01 RDI: ffffffff933cc0b0
[   36.479066] RBP: 00000000000056cc R08: 0000000000000001 R09: 0000000000000001
[   36.479619] R10: ffff8fced29208c0 R11: 0000000000000002 R12: 0000000000000000
[   36.480174] R13: 0000000000000000 R14: ffff8fced29208c0 R15: 0000000000000000
[   36.480736] FS:  00007f28d78db440(0000) GS:ffff8fd1cfe00000(0000) knlGS:0000000000000000
[   36.481303] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.481878] CR2: 00007f28d73f97a0 CR3: 000000010cfe0006 CR4: 00000000000706f0
[   36.482463] Call Trace:
[   36.483048]  <TASK>
[   36.483631]  inet_csk_listen_start+0x7a/0x100
[   36.484222]  inet_listen+0x70/0x100
[   36.484816]  __sys_listen+0x52/0xc0
[   36.485413]  __x64_sys_listen+0xb/0x40
[   36.486012]  do_syscall_64+0x5b/0xc0
[   36.486614]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[   36.487222] RIP: 0033:0x7f28d7322ae7
[   36.487832] Code: f0 ff ff 73 01 c3 48 8b 0d 86 23 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 32 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b
 0d 59 23 0d 00 f7 d8 64 89 01 48
[   36.488475] RSP: 002b:00007ffc37bad0d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
[   36.489134] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f28d7322ae7
[   36.489788] RDX: 0000000000000004 RSI: 0000000000000005 RDI: 0000000000000004
[   36.490444] RBP: 00000000ffffffff R08: 0000000000000007 R09: 000055f337d329c0
[   36.491104] R10: 00007ffc37bad114 R11: 0000000000000246 R12: 00007ffc37bad114
[   36.491757] R13: 0000000000000000 R14: 0000000000000005 R15: 000055f337d329a0
[   36.492407]  </TASK>
[   36.493043] ---[ end trace 0000000000000000 ]---

--SmY/0OTJntqgy1vw--
